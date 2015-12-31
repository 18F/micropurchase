Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github,
           ENV['MPT_3500_GITHUB_KEY'],
           ENV['MPT_3500_GITHUB_SECRET']
end
