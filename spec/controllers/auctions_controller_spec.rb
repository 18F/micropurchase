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

    context 'the list of auctions is sorted' do
      it 'renders them descending by datetime' do

        Timecop.freeze

        date_start = Time.current - 3.days
        date_latest = Time.current + 3.days
        date_middle = Time.current + 2.days
        date_first = Time.current + 1.days

        auction_record_1 = create(
          :auction,
          start_datetime: date_start,
          end_datetime: date_middle)

        auction_record_2 = create(
          :auction,
          start_datetime: date_start,
          end_datetime: date_latest)

        auction_record_3 = create(
          :auction,
          start_datetime: date_start,
          end_datetime: date_first)

        get :index
        auctions = assigns(:view_model).auctions

        auction_1 = auctions[0]
        auction_2 = auctions[1]
        auction_3 = auctions[2]

        expect(auction_1).to be_a(AuctionViewModel)
        expect(auction_1.end_datetime).to eq(date_latest)
        expect(auction_2.end_datetime).to eq(date_middle)
        expect(auction_3.end_datetime).to eq(date_first)
      end
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
