def current_user_uid
  '12345'
end

def github_auth_hash(opts={})
  OmniAuth::AuthHash.new({
    :provider => 'github',
    :uid => current_user_uid
  }.merge(opts))
end

def mock_github(opts={})
  OmniAuth.config.mock_auth[:github] = github_auth_hash(opts)
end

