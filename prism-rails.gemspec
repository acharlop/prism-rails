lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prism-rails/version'

Gem::Specification.new do |s|
  s.name          = "prism-rails"
  s.version       = Prism::VERSION
  s.authors       = ["Avi Charlop"]
  s.email         = "avicharlop@gmail.com"
  s.summary       = 'prism-rails wraps the Prism.js library in a rails engine for simple use with the asset pipeline'
  s.homepage      = 'https://github.com/acharlop/prism-rails'
  s.license       = "MIT"

  s.add_dependency "railties"

  s.add_development_dependency "bundler", "~> 1.11"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency 'uglifier'

  s.files         = Dir["{lib,vendor}/**/*"]
  s.require_paths = ["lib"]
end
