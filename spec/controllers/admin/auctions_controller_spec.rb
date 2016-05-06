require 'rails_helper'

describe Admin::AuctionsController do
  let(:user) { create(:admin_user) }

  describe '#index' do
    it 'assigns presented auctions' do
      auction_record = create(:auction)
      get :index, { }, user_id: user.id
      auctions = assigns(:auctions)
      expect(auctions).to be_a(Array)
      auction = auctions.first
      expect(auction).to be_a(AdminAuctionPresenter)
      expect(auction.id).to eq(auction_record.id)
    end
  end

  describe '#show' do
    it 'assigns presented auction' do
      auction_record = create(:auction)
      get :show, { id: auction_record.id }, user_id: user.id
      auction = assigns(:auction)
      expect(auction).to be_a(AdminAuctionPresenter)
      expect(auction.id).to eq(auction_record.id)
    end
  end
end
