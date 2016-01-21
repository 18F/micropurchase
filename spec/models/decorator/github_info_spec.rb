require "rails_helper"

RSpec.describe Decorator::GithubInfo do
  describe 'save' do
    let(:user) { FactoryGirl.create(:user) }
    let(:octokit_response) do
      OpenStruct.new(login: "glogin",
                     id: user.github_id,
                     avatar_url: "https://avatars.githubusercontent.com/u/2044?v=3",
                     gravatar_id: "",
                     url: "https://api.github.com/users/foo",
                     type: "User",
                     site_admin: false,
                     name: user.name,
                     company: "18F",
                     blog: "http://open.nytimes.com/",
                     location: "Washington, DC",
                     email: user.email,
                     hireable: nil,
                     bio: nil,
                     public_repos: 53,
                     public_gists: 27,
                     followers: 143,
                     following: 4,
                     created_at: Time.now,
                     updated_at: Time.now)
    end
    
    it "should update the user's github login" do
      allow_any_instance_of(Octokit::Client).
        to receive(:user).with(user.github_id).and_return(octokit_response)
      expect(octokit_response[:login]).to_not be_blank
      expect(user.github_login).to be_blank

      f = Decorator::GithubInfo.new(user)
      f.save

      expect(user.github_login).to eq(octokit_response.login)
    end

    it 'should do nothing if Octokit raises an error' do
      allow_any_instance_of(Octokit::Client).
        to receive(:user).and_raise(Octokit::NotFound)

      f = Decorator::GithubInfo.new(user)
      expect(user.github_login).to be_blank
      
      expect { f.save }.to_not raise_error

      expect(user.github_login).to be_blank
    end
  end
end
