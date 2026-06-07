#!/usr/bin/env ruby
# frozen_string_literal: true

require "date"
require "fileutils"
require "json"
require "optparse"
require "open3"
require "pathname"

ROOT = Pathname.new(__dir__).join("..").expand_path
EXTERNAL = ROOT.join("external_libraries")
PRISM_REPO = EXTERNAL.join("prism")
PRISM_THEMES_REPO = EXTERNAL.join("prism-themes")

VENDOR_JS = ROOT.join("vendor/assets/javascripts")
VENDOR_CSS = ROOT.join("vendor/assets/stylesheets")
LANGUAGES_DIR = VENDOR_JS.join("languages")
PLUGIN_JS_DIR = VENDOR_JS.join("prism-plugin")
PLUGIN_CSS_DIR = VENDOR_CSS.join("prism-plugin")
THEMES_DIR = VENDOR_CSS.join("prism-theme")

IMPORT_FILE = VENDOR_JS.join("prism.js")
VERSION_FILE = ROOT.join("lib/prism-rails/version.rb")
README_FILE = ROOT.join("README.md")
CHANGELOG_FILE = ROOT.join("CHANGELOG.md")
UPDATE_MESSAGE = "Update library to match latest Prism.js version"

options = {
  allow_dirty: false,
  commit: false,
  release: false,
  tag: nil
}

OptionParser.new do |parser|
  parser.banner = "Usage: ruby scripts/update_prism.rb [options]"
  parser.on("--allow-dirty", "Run even when the git working tree has changes") { options[:allow_dirty] = true }
  parser.on("--commit", "Commit the generated changes") { options[:commit] = true }
  parser.on("--release", "Run bundle update and rake release after committing") do
    options[:commit] = true
    options[:release] = true
  end
  parser.on("--tag TAG", "Use a specific Prism.js tag instead of the latest tag") { |tag| options[:tag] = tag }
end.parse!

def run!(*command, chdir: ROOT)
  stdout, stderr, status = Open3.capture3(*command, chdir: chdir.to_s)
  return stdout if status.success?

  warn stdout unless stdout.empty?
  warn stderr unless stderr.empty?
  abort "Command failed: #{command.join(' ')}"
end

def clean_worktree!
  return if run!("git", "status", "--porcelain").empty?

  abort "Exiting due to uncommitted git changes"
end

def clone_or_update!(name)
  FileUtils.mkdir_p(EXTERNAL)
  repo_path = EXTERNAL.join(name)

  unless repo_path.directory?
    run!("git", "clone", "https://github.com/PrismJS/#{name}.git", repo_path.to_s)
  end

  run!("git", "fetch", "--tags", "--quiet", chdir: repo_path)
  run!("git", "checkout", "master", "--quiet", chdir: repo_path)
  run!("git", "pull", "--quiet", "--ff-only", chdir: repo_path)
  repo_path
end

def latest_tag(repo_path)
  run!("git", "describe", "--tags", "--abbrev=0", chdir: repo_path).strip
end

def checkout_tag!(repo_path, tag)
  puts "Checking out #{repo_path.basename}: #{tag}"
  run!("git", "checkout", tag, "--quiet", chdir: repo_path)
end

def reset_directory!(path)
  FileUtils.rm_rf(path)
  FileUtils.mkdir_p(path)
end

def copy_matching(from, to, glob)
  FileUtils.mkdir_p(to)
  files = Dir[from.join(glob)].reject { |path| path.end_with?(".min.js") }.sort
  files.each { |path| FileUtils.cp(path, to) }
  puts "Copied #{files.length.to_s.rjust(4)} files from #{from.relative_path_from(ROOT)} to #{to.relative_path_from(ROOT)}"
  files
end

# Returns the language keys (e.g. "ruby", "erb") in an order that guarantees
# every language is required after the languages it depends on. Prism languages
# extend one another (erb -> ruby + markup-templating -> markup, cpp -> c, ...),
# so a plain alphabetical require order throws "Cannot set properties of
# undefined" at load time. The dependency graph lives in Prism's components.json.
def language_load_order
  components = JSON.parse(PRISM_REPO.join("components.json").read)
  languages = components.fetch("languages").reject { |key, _| key == "meta" }

  dependencies = languages.each_with_object({}) do |(key, meta), acc|
    deps = []
    if meta.is_a?(Hash)
      %w[require optional modify].each { |kind| deps.concat(Array(meta[kind])) }
    end
    acc[key] = deps
  end

  ordered = []
  visiting = {}
  visit = lambda do |key|
    return if ordered.include?(key) || visiting[key]

    visiting[key] = true
    dependencies.fetch(key, []).each { |dep| visit.call(dep) if dependencies.key?(dep) }
    visiting.delete(key)
    ordered << key
  end

  dependencies.keys.sort.each { |key| visit.call(key) }
  ordered
end

def write_import_file!(version)
  available = Dir[LANGUAGES_DIR.join("prism-*.js")].map { |path| File.basename(path, ".js").delete_prefix("prism-") }
  # prism-core must be required first; it defines the global Prism object that
  # every language file extends. The remaining languages follow in dependency
  # order so each one loads after the languages it builds on.
  ordered = ["core"] + language_load_order.select { |key| available.include?(key) && key != "core" }
  # Append any vendored language that is missing from components.json so no file
  # is ever silently dropped from the bundle.
  ordered += (available - ordered).sort
  language_files = ordered.map { |key| "prism-#{key}" }
  requires = language_files.map do |name|
    "//= require ./languages/#{name}"
  end

  footer = <<~JS.chomp

    if(typeof Turbolinks != 'undefined' && Turbolinks.supported) {
      document.addEventListener('turbolinks:load', function() {
        Prism.highlightAll()
      });
    }
  JS

  IMPORT_FILE.write(<<~JS)
    //! prism
    //! version     : #{version}
    //! authors     : Avi Charlop, Prismjs.com contributors
    //! license     : MIT
    //! languages : #{language_files.length}

    #{requires.join("\n")}
    #{footer}
  JS
end

def replace_between_markers!(content, start_marker, end_marker, replacement)
  start_index = content.index(start_marker)
  end_index = content.index(end_marker, start_index || 0)

  abort "Could not find README section between #{start_marker.inspect} and #{end_marker.inspect}" unless start_index && end_index

  prefix_end = content.index("\n", start_index + start_marker.length)
  abort "Could not find README section line ending after #{start_marker.inspect}" unless prefix_end

  before = content[0..prefix_end]
  after = content[end_index - 1..]
  "#{before}\n#{replacement}\n#{after}"
end

def update_readme!(version)
  readme = README_FILE.read
  readme.sub!(/^# prism-rails .+$/, "# prism-rails #{version}")

  themes = Dir[THEMES_DIR.join("prism-*.css")].sort.map do |path|
    "* #{File.basename(path, ".css").sub(/\Aprism-/, "")}"
  end.join("\n")

  plugin_names = Dir[PLUGIN_JS_DIR.join("prism-*.js")].map do |path|
    File.basename(path, ".js").sub(/\Aprism-/, "")
  end.sort

  abort "No Prism plugin JavaScript files were copied" if plugin_names.empty?

  plugins = plugin_names.map do |plugin|
    css = PLUGIN_CSS_DIR.join("prism-#{plugin}.css").file? ? ":white_check_mark:" : ":x:"
    "#{plugin} | #{css}"
  end

  plugin_table = ["Plugin | CSS", ":--- | :---", *plugins].join("\n")
  readme = replace_between_markers!(readme, "<div id=\"themes-list\"></div>", "### Plugins List", themes)
  readme = readme.sub(/(<div id="plugins-list"><\/div>\n\n).*\z/m) { "#{$1}#{plugin_table}\n" }
  README_FILE.write(readme)
end

def update_version_files!(version)
  VERSION_FILE.write(<<~RUBY)
    module PrismRails
      VERSION = "#{version}"
    end
  RUBY

  changelog = CHANGELOG_FILE.read
  return if changelog.match?(/^## #{Regexp.escape(version)} \(/)

  entry = "\n## #{version} (#{Date.today.strftime('%Y-%m-%d')})\n* #{UPDATE_MESSAGE}\n"
  CHANGELOG_FILE.write(changelog.sub(/\A(.*?\n)/, "\\1#{entry}"))
end

clean_worktree! unless options[:allow_dirty]

prism_repo = clone_or_update!("prism")
themes_repo = clone_or_update!("prism-themes")
tag = options[:tag] || latest_tag(prism_repo)
checkout_tag!(prism_repo, tag)
checkout_tag!(themes_repo, latest_tag(themes_repo))

version = tag.sub(/\Av/, "").sub(/-.*/, "")

[LANGUAGES_DIR, PLUGIN_JS_DIR, PLUGIN_CSS_DIR, THEMES_DIR].each { |path| reset_directory!(path) }

copy_matching(prism_repo.join("components"), LANGUAGES_DIR, "prism-*.js")
copy_matching(prism_repo.join("plugins"), PLUGIN_JS_DIR, "**/prism-*.js")
FileUtils.cp(prism_repo.join("themes/prism.css"), VENDOR_CSS.join("prism.css"))
copy_matching(prism_repo.join("plugins"), PLUGIN_CSS_DIR, "**/prism-*.css")
copy_matching(prism_repo.join("themes"), THEMES_DIR, "prism-*.css")
copy_matching(themes_repo.join("themes"), THEMES_DIR, "prism-*.css")

write_import_file!(version)
update_version_files!(version)
update_readme!(version)

if options[:commit]
  run!("git", "add", ".")
  run!("git", "commit", "-m", UPDATE_MESSAGE)
end

if options[:release]
  run!("bundle", "update")
  run!("bundle", "exec", "rake", "release")
end

puts "Updated prism-rails to Prism.js #{version}"
