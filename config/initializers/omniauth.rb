Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :github,
    Credentials.get('micropurchase-github', 'client_id'),
    Credentials.get('micropurchase-github', 'secret'),
    scope: "user:email"
  )
end
