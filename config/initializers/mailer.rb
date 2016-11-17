if Rails.env.production?
  protocol = "https"
end

Micropurchase::Application.config.action_mailer.default_url_options ||= {
  host: Credentials.get('micropurchase-smtp', 'default_url_host'),
  protocol: protocol || "http"
}
