# Prism-rails Changelog

## 1.30.0 (2026-06-07)
* Update bundled Prism.js assets to 1.30.0
* Update the asset updater to copy nested Prism plugin files, generate language requires in dependency order, and fail loudly when README sections cannot be rewritten
* Move the gem version constant from `Prism::VERSION` to `PrismRails::VERSION` to avoid colliding with Ruby's `prism` parser gem
* Add and document a Rails 8.1 demo app
* Update release documentation and local development setup for Ruby 3.2.2 and Bundler 2.4.10

For Prism.js changes see [Prism.js changelog](https://github.com/PrismJS/prism/blob/gh-pages/CHANGELOG.md)

## 1.29.0 (2024-03-02)

* Update library to match latest Prism.js version

## 1.19.0 (2020-03-07)

* Update library to match latest Prism.js version

## 1.6.0.3 (2017-02-07)

* BREAKING CHANGES: javascript importer file moved from prism-rails.js to prism.js
* Support for turbolinks(5) Thanks to [@simmerz](https://github.com/simmerz)

## 1.6.0.2 (2017-01-03)

* Support for rails 4

## 1.6.0 (2017-01-02)

* Require all languages in one file
* Sub directory for plugins js and css
