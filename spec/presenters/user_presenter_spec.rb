require 'rails_helper'

describe UserPresenter do
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
