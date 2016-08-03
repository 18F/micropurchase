require File.expand_path('../boot', __FILE__)

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
require_relative './load_cf_env'

Bundler.require(*Rails.groups)

module Micropurchase
  class Application < Rails::Application
    config.time_zone = 'Etc/UTC'
    config.active_record.raise_in_transactional_callbacks = true
    config.active_job.queue_adapter = :delayed_job
    config.assets.precompile += %w( *-bundle.js )

    config.middleware.insert_before 0, 'Rack::Cors' do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :put, :post, :options]
      end
    end
  end
end
