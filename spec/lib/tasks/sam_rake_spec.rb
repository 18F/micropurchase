require 'rails_helper'
require 'rake'

RSpec.describe 'rake sam:check' do

  before do
    allow(SamAccountReckoner).to receive(:new).and_return(reckoner)
    Micropurchase::Application.load_tasks
  end

  context 'when the sam_account for the user is false' do
    let!(:user) { FactoryGirl.create(:user, :with_duns_in_sam, sam_account: false) }
    let(:reckoner) { SamAccountReckoner.new(user) }
    
    it 'uses the SamAccountReckoner to determine whether the account is valid' do
      expect(SamAccountReckoner.unreckoned).to_not be_empty

      # need to return same user record because mocking
      expect(SamAccountReckoner).to receive(:unreckoned).and_return([user])
      expect(SamAccountReckoner).to receive(:new).with(user).and_return(reckoner)
      expect(reckoner).to receive(:user_in_sam?).and_return(true)

      Rake::Task['sam:check'].invoke

      expect(user).to be_sam_account
      expect(User.where(sam_account: false)).to be_empty
    end
  end

  context 'when the sam_account is true for the user' do
    let!(:user) { FactoryGirl.create(:user, :with_duns_in_sam, sam_account: true) }
    let(:reckoner) { SamAccountReckoner.new(user) }

    it 'does not use the reckoner and keeps the account as it is' do
      expect(reckoner).to_not receive(:set)
      Rake::Task['sam:check'].invoke
    end
  end
end
