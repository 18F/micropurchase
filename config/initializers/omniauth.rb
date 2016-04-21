Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github,
          GithubCredentials.client_id,
          GithubCredentials.secret
end
