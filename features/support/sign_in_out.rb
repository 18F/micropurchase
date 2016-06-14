OmniAuth.config.test_mode = true

def mock_sign_in(github_id, name)
  OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
    provider: 'github',
    uid: github_id,
    info: {
      name: name,
      nickname: 'github_username',
      email: 'email@example.com'
    }
  )
end
