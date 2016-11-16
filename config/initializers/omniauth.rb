require_relative "credentials_map"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :github,
    Credentials.github_client_id,
    Credentials.github_secret,
    scope: "user:email"
  )
end
