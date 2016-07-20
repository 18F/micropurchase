require 'rails_helper'

describe Admin::AuctionShowViewModel do
  context 'auction for default purchase card' do
    it 'returns c2 proposal URL and approved at fields' do
      auction = create(:auction, purchase_card: :default)
      user = create(:user)

      view_model = Admin::AuctionShowViewModel.new(auction: auction, current_user: user)
      data = view_model.admin_data

      expect(data).to have_key('C2 proposal URL')
      expect(data).to have_key('C2 approved at')
    end
  end

  context 'auction for other purchase card' do
    it 'does not return c2 proposal URL or approved at fields' do
      auction = create(:auction, purchase_card: :other)
      user = create(:user)

      view_model = Admin::AuctionShowViewModel.new(auction: auction, current_user: user)
      data = view_model.admin_data

      expect(data).not_to have_key('C2 proposal URL')
      expect(data).not_to have_key('C2 approved at')
    end
  end
end
