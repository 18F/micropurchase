def current_user_uid
  '12345'
end

def github_auth_hash(opts = { })
  OmniAuth::AuthHash.new({
    provider: 'github',
    uid: current_user_uid,
    info: {
      name: 'Doris Doogooder',
      email: 'test@example.com',
      nickname: 'github_username'
    }
  }.merge(opts))
end

def mock_github(opts = { })
  OmniAuth.config.mock_auth[:github] = github_auth_hash(opts)
end
