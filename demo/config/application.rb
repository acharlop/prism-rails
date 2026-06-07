require_relative "boot"

require "rails"
require "action_controller/railtie"
require "action_view/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module PrismRailsDemo
  class Application < Rails::Application
    config.load_defaults 8.1
    config.eager_load = false
    config.secret_key_base = "development-secret"
    config.assets.precompile += %w[application.js application.css]
  end
end
