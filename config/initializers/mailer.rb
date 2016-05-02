if Rails.env.production?
  protocol = "https"
end

Micropurchase::Application.config.action_mailer.default_url_options ||= {
  host: SMTPCredentials.default_url_host,
  protocol: protocol || "http"
}
