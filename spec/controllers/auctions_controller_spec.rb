require 'rails_helper'

describe AuctionsController do
  describe '#index' do
    it 'assigns presented auctions' do
      auction_record = create(:auction)
      get :index
      auction = assigns(:view_model).auctions.first
      expect(auction).to be_a(AuctionViewModel)
      expect(auction.id).to eq(auction_record.id)
    end
  end

  describe '#show' do
    it 'assigns presented auction' do
      auction_record = create(:auction)
      get :show, id: auction_record.id
      auction = assigns(:view_model).auction
      expect(auction).to be_a(AuctionViewModel)
      expect(auction.id).to eq(auction_record.id)
    end

    context 'when the auction is published' do
      it 'assigns presented auction' do
        auction_record = create(:auction, :published)
        get :show, id: auction_record.id
        auction = assigns(:view_model)
        expect(auction).to be_a(AuctionShowViewModel)
        expect(auction.auction.id).to eq(auction_record.id)
      end
    end

    context 'when the auction is not published' do
      it 'renders an error page' do
        auction_record = create(:auction, :unpublished)
        expect do
          get :show, id: auction_record.id
        end.to raise_error ActionController::RoutingError
      end
    end
  end

  describe '#previous_winners' do
    it 'renders the previous winners dashboard page' do
      auction_record = create(:auction)
      get :previous_winners
      auction = assigns(:view_model).auctions.first
      expect(auction).to be_a(AuctionViewModel)
      expect(auction.id).to eq(auction_record.id)
    end
  end

  describe '#previous_winners_archive' do
    it 'renders the previous winners archive page' do
      auction_record = create(:auction)
      get :previous_winners_archive
      auction = assigns(:view_model).auctions.first
      expect(auction).to be_a(AuctionViewModel)
      expect(auction.id).to eq(auction_record.id)
    end
  end
end
