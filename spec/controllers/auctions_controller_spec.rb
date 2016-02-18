require 'rails_helper'

RSpec.describe AuctionsController, controller: true do
  describe '#index' do
    it 'assigns presented auctions' do
      auction_record = FactoryGirl.create(:auction)
      get :index
      auction = assigns(:view_model).auctions.first
      expect(auction).to be_a(Presenter::Auction)
      expect(auction.id).to eq(auction_record.id)
    end
  end

  describe '#show' do
    it 'assigns presented auction' do
      auction_record = FactoryGirl.create(:auction)
      get :show, id: auction_record.id
      auction = assigns(:view_model).auction
      expect(auction).to be_a(Presenter::Auction)
      expect(auction.id).to eq(auction_record.id)
    end

    context 'when the auction is published' do
      it 'assigns presented auction' do
        auction_record = FactoryGirl.create(:auction, :published)
        get :show, id: auction_record.id
        auction = assigns(:view_model)
        expect(auction).to be_a(ViewModel::AuctionShow)
        expect(auction.auction.id).to eq(auction_record.id)
      end
    end

    context 'when the auction is not published' do
      it 'renders an error page' do
        auction_record = FactoryGirl.create(:auction, :unpublished)
        expect do
          get :show, id: auction_record.id
        end.to raise_error ActionController::RoutingError
      end
    end
  end
end
