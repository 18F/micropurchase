require 'rails_helper'

RSpec.describe UserPresenter do
  describe '#in_sam?' do
    it "should return true when the user's sam_status is sam_accepted" do
      user = UserPresenter.new(create(:user, sam_status: :sam_accepted))
      expect(user).to be_in_sam
      expect(user.sam_status_label).to eq('Yes')
    end

    it "should return false when the user's sam_status is sam_pending" do
      user = UserPresenter.new(create(:user, sam_status: :sam_pending))
      expect(user).to_not be_in_sam
      expect(user.sam_status_label).to eq('No')
    end

    it "should return false when the user's sam_status is sam_rejected" do
      user = UserPresenter.new(create(:user, sam_status: :sam_rejected))
      expect(user).to_not be_in_sam
      expect(user.sam_status_label).to eq('No')
    end

    it "should return false when the user's sam_status is duns_blank" do
      user = UserPresenter.new(create(:user, sam_status: :duns_blank))
      expect(user).to_not be_in_sam
      expect(user.sam_status_label).to eq('No')
    end
  end

  describe '#small_business_label' do
    it 'should return "N/A" if the user is not in_sam' do
      user = UserPresenter.new(create(:user, sam_status: :sam_pending, small_business: true))
      expect(user.small_business_label).to eq("N/A")
    end

    it 'should return "Yes" if the user is in SAM and a small business' do
      user = UserPresenter.new(create(:user, :small_business))
      expect(user.small_business_label).to eq("Yes")
    end

    it 'should return "No" if the user is in SAM and not a small business' do
      user = UserPresenter.new(create(:user, :not_small_business))
      expect(user.small_business_label).to eq("No")
    end
  end
end
