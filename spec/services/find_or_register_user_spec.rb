require 'rails_helper'

describe FindOrRegisterUser do
  describe '#perform' do
    context 'when the user does not exist' do
      it 'creates a new user' do
        github_id = 123456789

        expect do
          FindOrRegisterUser.new(github_id: github_id).perform
        end.to change { User.count }.by(1)
      end

      it 'returns the new user' do
        github_id = '123456789'
        user = FindOrRegisterUser.new(github_id: github_id).perform

        expect(user).to be_a(User)
        expect(user.github_id).to eq(github_id)
      end
    end

    context 'when the user exists' do
      it 'does not create a new user' do
        github_id = 123456789
        user = create(:user, github_id: github_id)

        expect do
          FindOrRegisterUser.new(github_id: github_id).perform
        end.not_to change { User.count }
      end

      it 'returns the existing user' do
        github_id = 123456789
        user = create(:user, github_id: github_id)

        returned_user = FindOrRegisterUser.new(github_id: github_id).perform

        expect(returned_user).to be_a(User)
        expect(returned_user.id).to eq(user.id)
      end
    end
  end
end
