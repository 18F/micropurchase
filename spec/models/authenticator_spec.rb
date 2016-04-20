require 'rails_helper'

RSpec.describe Authenticator do
  let(:authenticator) { Authenticator.new(auth_hash, session) }
  let(:auth_hash) do
    OmniAuth::AuthHash.new(
      provider: 'github',
      uid: '12345',
      info: {
        name: 'Kane',
        email: 'email@gemal.com',
        image: 'github-image.png'
      }
    )
  end
  let(:session) { {} }

  context 'when the uid exists in a user' do
    let!(:user) { FactoryGirl.create(:user, github_id: '12345', name: nil) }

    it 'does not create a new user' do
      expect { authenticator.perform }.to_not change { User.count }
    end

    it 'updates the user with additional data' do
      authenticator.perform
      user.reload
      expect(user.name).to eq('Kane')
    end

    it 'signs in the user into the session' do
      authenticator.perform
      expect(session[:user_id]).to eq(user.id)
    end

    it 'returns the redirect path' do
      expect(authenticator.perform)
        .to eq(controller: :users,
               action: :edit,
               id: user.id,
               only_path: true)
    end
  end

  context 'when the uid does not exist' do
    let(:user) { User.where(github_id: '12345').first }

    it 'creates a new user' do
      expect { authenticator.perform }.to change { User.count }
      expect(user.name).to eq('Kane')
    end

    it 'signs in the user into the session' do
      authenticator.perform
      expect(session[:user_id]).to eq(user.id)
    end

    it 'returns the redirect path' do
      expect(authenticator.perform)
        .to eq(controller: :users,
               action: :edit,
               id: user.id,
               only_path: true)
    end
  end

  context 'when the user is an admin' do
    let(:admin_uid) { Admins.github_ids.first }

    let(:auth_hash) do
      OmniAuth::AuthHash.new(
        provider: 'github',
        uid: admin_uid,
        info: {
          name: 'Kane',
          email: 'email@gemal.com',
          image: 'github-image.png'})
    end

    it 'has the redirect url as home' do
      expect(authenticator.perform)
        .to eq(controller: :auctions,
               action: :index,
               only_path: true)
    end
  end
end
