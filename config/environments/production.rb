require_relative '../../lib/conditional_asset_compressor'

Rails.application.configure do
  config.action_mailer.smtp_settings = {
    address: 'smtp.mandrillapp.com',
    port: 587,
    domain: ENV['SMTP_DOMAIN'] || "18f.gsa.gov",
    user_name: Credentials.get('micropurchase-smtp', 'smtp_username'),
    password:  Credentials.get('micropurchase-smtp', 'smtp_password'),
    authentication: 'login',
    enable_starttls_auto: true
  }

  config.action_controller.perform_caching = true
  config.active_record.dump_schema_after_migration = false
  config.active_support.deprecation = :notify
  config.assets.compile = false
  config.assets.digest = true
  config.assets.js_compressor = ConditionalAssetCompressor.new
  config.cache_classes = true
  config.consider_all_requests_local = false
  config.eager_load = true
  config.force_ssl = true
  config.i18n.fallbacks = true
  config.log_formatter = ::Logger::Formatter.new
  config.log_level = :debug
  config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?
end
