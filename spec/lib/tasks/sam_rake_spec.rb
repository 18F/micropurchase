require 'rails_helper'
require 'rake'

RSpec.describe 'rake sam:check' do
  let(:reckoner) { double('sam account reckoner', set: true, clear: false) }

  before do
    allow(SamAccountReckoner).to receive(:new).and_return(reckoner)
    Micropurchase::Application.load_tasks
  end

  context 'when the sam_account for the user is false' do
    let!(:user) { FactoryGirl.create(:user, :with_duns_in_sam, sam_account: false) }

    it 'uses the SamAccountReckoner to determine whether the account is valid' do
      expect(SamAccountReckoner).to receive(:new).with(user).and_return(reckoner)
      expect(reckoner).to receive(:set)
      Rake::Task['sam:check'].invoke
    end
  end

  context 'when the sam_account is true for the user' do
    let!(:user) { FactoryGirl.create(:user, :with_duns_in_sam, sam_account: true) }

    it 'does not use the reckoner and keeps the account as it is' do
      expect(reckoner).to_not receive(:set)
      Rake::Task['sam:check'].invoke
    end
  end
end
