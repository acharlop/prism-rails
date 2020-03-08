# prism-rails 1.19.0

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

* a11y-dark
* atom-dark
* autolinker
* base16-ateliersulphurpool.light
* cb
* command-line
* coy
* darcula
* dark
* dracula
* duotone-dark
* duotone-earth
* duotone-forest
* duotone-light
* duotone-sea
* duotone-space
* funky
* ghcolors
* hopscotch
* line-highlight
* line-numbers
* material-dark
* material-light
* material-oceanic
* nord
* okaidia
* pojoaque
* previewers
* shades-of-purple
* show-invisibles
* show-language
* solarizedlight
* synthwave84
* tomorrow
* toolbar
* twilight
* unescaped-markup
* vs
* vsc-dark-plus
* wpd
* xonokai

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
ie8 | :white_check_mark:
inline-color | :white_check_mark:
jsonp-highlight | :x:
keep-markup | :x:
line-highlight | :white_check_mark:
line-numbers | :white_check_mark:
match-braces | :white_check_mark:
normalize-whitespace | :x:
previewer-angle | :white_check_mark:
previewer-base | :white_check_mark:
previewer-color | :white_check_mark:
previewer-easing | :white_check_mark:
previewer-gradient | :white_check_mark:
previewer-time | :white_check_mark:
previewers | :white_check_mark:
remove-initial-line-feed | :x:
show-invisibles | :white_check_mark:
show-language | :x:
toolbar | :white_check_mark:
unescaped-markup | :white_check_mark:
wpd | :white_check_mark:
