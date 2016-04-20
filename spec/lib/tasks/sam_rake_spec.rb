require 'rails_helper'
require 'rake'

RSpec.describe 'rake sam:check' do
  context 'when the sam_account for the user is false' do
    it 'uses the SamAccountReckoner to determine whether the account is valid' do
      user = FactoryGirl.create(:user, sam_account: false)
      Micropurchase::Application.load_tasks
      client = double('samwise client')
      expect(client).to receive(:duns_is_in_sam?).and_return(true)
      expect(Samwise::Client).to receive(:new).and_return(client)

      Rake::Task['sam:check'].execute

      user = User.first
      expect(user).to be_sam_account
      expect(User.where(sam_account: false)).to be_empty
    end
  end

  context 'when the sam_account is true for the user' do
    it 'does not use the reckoner and keeps the account as it is' do
      user = FactoryGirl.create(:user, sam_account: true)
      reckoner = SamAccountReckoner.new(user)
      Micropurchase::Application.load_tasks
      allow(SamAccountReckoner).to receive(:new).and_return(reckoner)

      expect(reckoner).to_not receive(:set)

      Rake::Task['sam:check'].execute
    end
  end
end
