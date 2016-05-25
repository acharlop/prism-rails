# prism-rails

prism-rails wraps the Prism.js library in a rails engine for simple use with the asset pipeline

Prism is a lightweight, robust, elegant syntax highlighting library.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'prism-rails'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install prism-rails

## Usage

### Install prism-rails gem

add `prism-rails` to your Gemfile and run `bundle install`:

```ruby
gem "prism-rails"
```

### Include prism-rails javascript assets

Add the following to your `app/assets/javascripts/application.js`:

```ruby
//= require prism
```

### include prism-rails stylesheet assets

```ruby
*= require prism
```

Or use one of the other themes see [Prism](http://prismjs.com) and [prism-themes](https://github.com/PrismJS/prism-themes) for examples

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

## Plugins

See [Prism](http://prismjs.com/#plugins) for more details about the plugins

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

### Include plugin javascript assets

Add the following to your `app/assets/javascripts/application.js`:

```ruby
//= require prism-[plugin-name]
```

### include prism-rails stylesheet assets

```ruby
*= require prism-[plugin-name]
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/acharlop/prism-rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

