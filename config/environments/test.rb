Rails.application.configure do
  config.cache_classes = true
  config.eager_load = false
  config.serve_static_files = true
  config.static_cache_control = 'public, max-age=3600'
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.action_dispatch.show_exceptions = false
  config.action_controller.allow_forgery_protection = false
  config.action_mailer.delivery_method = :test
  config.action_mailer.default_url_options = { host: "http://localhost:3000" }
  config.active_support.test_order = :random
  config.active_support.deprecation = :stderr
  config.action_view.raise_on_missing_translations = true
  ENV['VCAP_SERVICES'] = File.read("#{Rails.root}/spec/support/vcap_services.json")
  ENV['VCAP_APPLICATION'] = File.read("#{Rails.root}/spec/support/vcap_application.json")
end
