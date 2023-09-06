require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsNewsjack
  class Application < Rails::Application
    config.generators do |generate|
      generate.assets false
      generate.helper false
      generate.test_framework :test_unit, fixture: false
    end

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    require "active_job/railtie" # <== !! Uncomment
    require "action_mailer/railtie"  # <==  !! Uncomment
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
<<<<<<< HEAD
    require 'dotenv'
    Dotenv.load(File.expand_path('../.env', __dir__))
      end
=======
  end
>>>>>>> 0222e2c8bd5f32bbdc9bdd962e09332781f34aea
end
