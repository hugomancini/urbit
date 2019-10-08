require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ConticiniPrivate
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

   config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'https://thomas-test-theme.myshopify.com/cart', 'https://philippeconticini.fr'
        resource(
          '*',
          headers: :any,
          methods: :any)
      end
    end
  end
end
