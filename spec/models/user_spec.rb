require 'rails_helper'

describe User do
  describe "#from_oauth_hash" do
    context "user does not have github username, name, or email" do
      it "updates from auth hash" do
        user = FactoryGirl.create(:user, github_login: nil, name: nil, email: nil)
        auth_hash = {
          info: {
            nickname: "github_username",
            name: "Person",
            email: "test@example.com"
          }
        }

        user.from_oauth_hash(auth_hash)

        expect(user.github_login).to eq "github_username"
        expect(user.name).to eq "Person"
        expect(user.email).to eq "test@example.com"
      end
    end

    context "user already has github username, name, and email" do
      it "does not update email, name, does update github username" do
        user = FactoryGirl.create(
          :user,
          github_login: "Old_Username",
          name: "Old name",
          email: "oldemail@example.com"
        )
        auth_hash = {
          info: {
            nickname: "New_Username",
            name: "New name",
            email: "test@example.com"
          }
        }

        user.from_oauth_hash(auth_hash)

        expect(user.github_login).to eq "New_Username"
        expect(user.name).to eq "Old name"
        expect(user.email).to eq "oldemail@example.com"
      end
    end
  end
end
