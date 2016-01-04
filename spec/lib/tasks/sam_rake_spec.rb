require 'rails_helper'
require 'rake'

RSpec.describe 'rake sam:check' do
  before do
    Micropurchase::Application.load_tasks
  end

  context 'when the database contains users with a mix of valid and invalid DUNSes' do
    let(:valid_duns) { '130477032' }
    before do
      @nil_users = []
      5.times do
        @nil_users << FactoryGirl.create(:user, duns_number: nil, sam_account: false)
      end

      @valid_users = []
      5.times do
        @valid_users << FactoryGirl.create(:user, :with_duns_in_sam, sam_account: false)
      end

      @miss_users = []
      5.times do
        @miss_users << FactoryGirl.create(:user, :with_duns_not_in_sam, sam_account: false)
      end
    end

    

    it 'should make sam_account true for users who have DUNSes in sam' do
      allow(User).to receive(:registered_on_sam?).and_wrap_original { false }
      allow(User).to receive(:registered_on_sam?).with(duns: @valid_users.first.duns_number).and_return(true)

      expect(User.where(sam_account: true).count).to eq(0)

      expect do
        Rake::Task['sam:check'].invoke
      end.to_not raise_error
      
      @valid_users.each(&:reload)
      expect(User.where(sam_account: true).count).to eq(@valid_users.length)
      expect(@valid_users).to all(be_sam_account)

    end
  end
end
