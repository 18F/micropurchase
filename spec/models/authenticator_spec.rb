require 'spec_helper'

RSpec.describe Authenticator do
  let(:authenticator) { Authenticator.new(auth_hash, session) }

  let(:auth_hash) {
    OmniAuth::AuthHash.new({
      :provider => 'github',
      :uid => '12345',
      :info => {
        name: 'Kane',
        email: 'email@gemal.com',
        image: 'github-image.png'
      }
    })
  }

  let(:session) {
    {}
  }

  before do
    User.delete_all
  end

  context 'when the uid exists in a user' do
    let!(:user) { User.create(github_id: '12345') }

    it 'does not create a new user' do
      expect {
        authenticator.perform
      }.to_not change { User.count }
    end

    it 'signs in the user into the session' do
      authenticator.perform
      expect(session[:user_id]).to eq(user.id)
    end

    it 'returns the redirect path' do
      expect(authenticator.perform).to eq("/users/#{user.id}/edit")
    end
  end

  context 'when the uid does not exist' do
    let(:user) { User.where(github_id: '12345').first }

    it 'creates a new user' do
      expect {
        authenticator.perform
      }.to change { User.count }
    end

    it 'signs in the user into the session' do
      authenticator.perform
      expect(session[:user_id]).to eq(user.id)
    end

    it 'returns the redirect path' do
      expect(authenticator.perform).to eq("/users/#{user.id}/edit")
    end
  end

  context 'when the user is an admin' do
    let(:admin_uid) { Admins.github_ids.first }

    let(:auth_hash) {
      OmniAuth::AuthHash.new({
        :provider => 'github',
        :uid => admin_uid,
        :info => {
          name: 'Kane',
          email: 'email@gemal.com',
          image: 'github-image.png'
        }
      })
    }


    it 'has the redirect url as home' do
      expect(authenticator.perform).to eq("/")
    end
  end
end
