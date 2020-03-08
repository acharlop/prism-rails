# prism-rails 1.16.0

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

### Contributors
[@simmerz](https://github.com/simmerz)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

### Themes List
<div id="themes-list"></div>

* atom-dark
* base16-ateliersulphurpool.light
* cb
* coy
* dark
* duotone-dark
* duotone-earth
* duotone-forest
* duotone-light
* duotone-sea
* duotone-space
* funky
* ghcolors
* hopscotch
* okaidia
* pojoaque
* solarizedlight
* tomorrow
* twilight
* xonokai

### Plugins List
<div id="plugins-list"></div>

* autolinker
* command-line
* ie8
* line-highlight
* line-numbers
* previewer-angle
* previewer-base
* previewer-color
* previewer-easing
* previewer-gradient
* previewer-time
* show-invisibles
* show-language
* unescaped-markup
* wpd
