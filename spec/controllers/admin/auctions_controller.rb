require 'rails_helper'

RSpec.describe Admin::AuctionsController, controller: true do
  describe '#index' do
    it 'assigns presented auctions' do
      auction_record = FactoryGirl.create(:auction)
      get :index
      auction = assigns(:auctions).first
      expect(auction).to be_a(Presenter::Auction)
      expect(auction.id).to eq(auction_record.id)
    end
  end

  describe '#show' do
    it 'assigns presented auction' do
      auction_record = FactoryGirl.create(:auction)
      get :show, id: auction_record.id
      auction = assigns(:auction)
      expect(auction).to be_a(Presenter::Auction)
      expect(auction.id).to eq(auction_record.id)
    end
  end
end
