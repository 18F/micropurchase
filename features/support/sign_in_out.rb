OmniAuth.config.test_mode = true

def sign_in(user)
  OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
    provider: 'github',
    uid: user.github_id
  )
end
