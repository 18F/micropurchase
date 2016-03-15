require 'rails_helper'

RSpec.describe GithubReckoner do
  let(:user) { FactoryGirl.create(:user) }
  let(:reckoner) { GithubReckoner.new(user) }
  let(:client) { instance_double(Octokit::Client) }
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

  before do
    allow(Octokit::Client).to receive(:new).and_return(client)
  end

  describe '#set' do
    context 'when Octokit returns normally' do
      it 'should set the github_login' do
        expect(client).to receive(:user).with(user.github_id).and_return(octokit_response)
        reckoner.set
        expect(user.github_login).to eq(octokit_response[:login])
      end
    end
    
    context 'when Octokit raises an error' do
      it 'should not set the github_login' do
        expect(client).to receive(:user).with(user.github_id).and_raise(Octokit::NotFound)
        expect { reckoner.set }.to_not raise_error
        expect(user.github_login).to be_blank
      end
    end
  end
end
