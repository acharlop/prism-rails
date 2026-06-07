# prism-rails 1.30.0

prism-rails wraps the [Prism.js](https://github.com/PrismJS/prism) library in a rails engine for simple use with the asset pipeline

Prism is a lightweight, robust, elegant syntax highlighting library.

## Usage

Add the following to your application's Gemfile and run `bundle install`:

```ruby
gem 'prism-rails'
```

Add the following to your Javascript manifest file `application.js`:

```ruby
//= require prism
```

Add the css for the default styling `application.css`:

```ruby
*= require prism
```

## Themes

See [Prism](http://prismjs.com) and [prism-themes](https://github.com/PrismJS/prism-themes) for examples.

For a full list of themes see [below](#themes-list)

```ruby
//= require prism-plugin/prism-[plugin-name]
```

If necessary add the following to your `application.scss`:

```ruby
*= require prism-plugin/prism-[plugin-name]
```

## Versioning
prism-rails 1.6.0 == Prism.js 1.6.0
Every attempt is made to mirror the currently shipping Prism.js version number wherever possible. The major, minor, and patch version numbers will always represent the Prism.js version. Should a gem bug be discovered, a 4th version identifier will be added and incremented.

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/acharlop/prism-rails).

## Maintaining

Use the updater to sync vendored assets with the latest Prism.js tag. The updater checks out the latest Prism and prism-themes tags, refreshes files under `vendor/assets`, updates `lib/prism-rails/version.rb`, rewrites the README theme/plugin lists, and adds a CHANGELOG entry.

Recommended release flow:

```sh
rbenv install 3.2.2 # if needed
rbenv local 3.2.2
gem install bundler -v 2.4.10
rbenv rehash
bundle install
ruby scripts/update_prism.rb
git diff
bundle exec rake test
cd demo
bundle install
bin/rails server
```

Open [http://localhost:3000](http://localhost:3000) and confirm the demo renders highlighted Ruby, JavaScript, and ERB snippets. Then commit and release:

```sh
git add .
git commit -m "Update library to match latest Prism.js version"
bundle update
bundle exec rake release
```

You can pin a specific Prism.js tag when needed:

```sh
ruby scripts/update_prism.rb --tag v1.30.0
```

Automation shortcuts are also available: `ruby scripts/update_prism.rb --commit` creates the update commit, and `ruby scripts/update_prism.rb --release` commits, runs `bundle update`, and runs `bundle exec rake release`. Use those only when you do not need a manual review step. The legacy `./update-script.sh true` entry point still maps to the release shortcut.

## Demo App

A Rails 8.1 demo lives in `demo`:

```sh
cd demo
bundle install
bin/rails server
```

The demo requires Ruby 3.2 or newer. It loads this gem from the local checkout, serves Prism through the Rails asset pipeline, and renders highlighted Ruby, JavaScript, and ERB examples. After the server starts, open [http://localhost:3000](http://localhost:3000).

If `bundle install` fails with `undefined method 'untaint'`, Ruby is running Bundler 1.x. Install Bundler 2.4.10 and run `rbenv rehash`, then retry `bundle install`.

### Contributors
[@simmerz](https://github.com/simmerz)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

### Themes List
<div id="themes-list"></div>

* a11y-dark
* atom-dark
* base16-ateliersulphurpool.light
* cb
* coldark-cold
* coldark-dark
* coy-without-shadows
* coy
* coy.min
* darcula
* dark
* dark.min
* dracula
* duotone-dark
* duotone-earth
* duotone-forest
* duotone-light
* duotone-sea
* duotone-space
* funky
* funky.min
* ghcolors
* gruvbox-dark
* gruvbox-light
* holi-theme
* hopscotch
* lucario
* material-dark
* material-light
* material-oceanic
* night-owl
* nord
* okaidia
* okaidia.min
* one-dark
* one-light
* pojoaque
* shades-of-purple
* solarized-dark-atom
* solarizedlight
* solarizedlight.min
* synthwave84
* tomorrow
* tomorrow.min
* twilight
* twilight.min
* vs
* vsc-dark-plus
* xonokai
* z-touch

### Plugins List
<div id="plugins-list"></div>

Plugin | CSS
:--- | :---
autolinker | :white_check_mark:
autoloader | :x:
command-line | :white_check_mark:
copy-to-clipboard | :x:
custom-class | :x:
data-uri-highlight | :x:
diff-highlight | :white_check_mark:
download-button | :x:
file-highlight | :x:
filter-highlight-all | :x:
highlight-keywords | :x:
inline-color | :white_check_mark:
jsonp-highlight | :x:
keep-markup | :x:
line-highlight | :white_check_mark:
line-numbers | :white_check_mark:
match-braces | :white_check_mark:
normalize-whitespace | :x:
previewers | :white_check_mark:
remove-initial-line-feed | :x:
show-invisibles | :white_check_mark:
show-language | :x:
toolbar | :white_check_mark:
treeview | :white_check_mark:
unescaped-markup | :white_check_mark:
wpd | :white_check_mark:
