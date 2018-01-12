require_relative 'boot'

require 'rails/all'
Bundler.require(*Rails.groups)

module Froggo
  class Application < Rails::Application
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*',
          headers: :any,
          expose: ['X-Page', 'X-PageTotal'],
          methods: [:get, :post, :delete, :put, :options]
      end
    end
    config.i18n.default_locale = 'es-CL'
    config.i18n.fallbacks = [:es, :en]

    config.active_job.queue_adapter = :sidekiq
    config.assets.paths << Rails.root.join('node_modules')
    config.load_defaults 5.1
  end
end
