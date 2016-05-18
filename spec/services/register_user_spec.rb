require 'rails_helper'

describe RegisterUser do
  describe '#perform' do
    it 'creates a new user' do
      expect do
        RegisterUser.new(github_id: '123456789').perform
      end.to change { User.count }.by(1)
    end

    it 'returns a user object' do
      github_id = '123456789'
      user = RegisterUser.new(github_id: github_id).perform
      expect(user).to be_a(User)
      expect(user.github_id).to eq(github_id)
    end
  end
end
