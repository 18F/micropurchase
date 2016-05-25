require 'rails_helper'

describe AuctionsController do
  describe '#index' do
    context 'the list of auctions is sorted' do
      it 'renders them descending by datetime' do
        Timecop.freeze
        date_start = Time.current - 3.days
        date_latest = Time.current + 3.days
        date_middle = Time.current + 2.days
        date_first = Time.current + 1.days

        create(
          :auction,
          started_at: date_start,
          ended_at: date_middle)

        create(
          :auction,
          started_at: date_start,
          ended_at: date_latest)

        create(
          :auction,
          started_at: date_start,
          ended_at: date_first)

        get :index
        auctions = assigns(:auctions).auctions

        auction_1 = auctions[0]
        auction_2 = auctions[1]
        auction_3 = auctions[2]

        expect(auction_1.ended_at).to be_within(0.1).of(date_latest)
        expect(auction_2.ended_at).to be_within(0.1).of(date_middle)
        expect(auction_3.ended_at).to be_within(0.1).of(date_first)
      end
    end
  end

  describe '#show' do
    context 'when the auction is published' do
      it 'assigns presented auction' do
        auction_record = create(:auction, :published)
        get :show, id: auction_record.id
        auction = assigns(:view_model)
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
      expect(auction.id).to eq(auction_record.id)
    end
  end
end
