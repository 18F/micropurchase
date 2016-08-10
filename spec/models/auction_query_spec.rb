require 'rails_helper'
describe AuctionQuery do
  let(:query) { AuctionQuery.new }

  describe '#completed' do
    it 'returns published auctions with bids where delivery deadline is in past' do
      completed = create(:auction, :complete_and_successful)
      payment_needed = create(:auction, :with_bidders, :payment_needed)
      create(:auction, :available)

      expect(query.completed).to match_array([completed, payment_needed])
    end
  end

  describe '#complete_and_successful' do
    let(:complete_and_successful) do
      create(:auction, :complete_and_successful)
    end
    let!(:running_auction) { create(:auction, :running) }
    let!(:rejected_auction) { create(:auction, result: :rejected) }
    let!(:unpaid_auction) do
      create(:auction, :not_paid)
    end
    let(:anomolous_auction) { create(:auction, :rejected, :paid) }

    it 'should only return complete and successful auctions' do
      expect(query.complete_and_successful)
        .to match_array([complete_and_successful])
    end
  end

  describe '#rejected' do
    let!(:complete_and_successful) do
      create(:auction, :complete_and_successful)
    end
    let!(:rejected_auction) { create(:auction, result: :rejected) }

    it 'should only return unpublished auctions' do
      expect(query.rejected).to match_array([rejected_auction])
    end
  end

  describe '#payment_needed' do
    let(:payment_needed) { create(:auction, :payment_needed) }
    let!(:running_auction) { create(:auction, :running) }
    let!(:complete_and_successful) do
      create(:auction, :complete_and_successful)
    end

    it 'should only return auctions where payment is needed' do
      expect(query.payment_needed).to match_array([payment_needed])
    end
  end

  describe '#pending_acceptance' do
    let(:pending_acceptance) { create(:auction, :pending_acceptance) }
    let!(:complete_and_successful) do
      create(:auction, :complete_and_successful)
    end
    let!(:running_auction) { create(:auction, :running) }
    let!(:payment_needed) { create(:auction, :payment_needed) }

    it 'should only return auctions where an evaluation is needed' do
      expect(query.pending_acceptance).to match_array([pending_acceptance])
    end
  end

  describe '#delivery_past_due' do
    let(:delivery_past_due) { create(:auction, :delivery_past_due) }
    let!(:complete_and_successful) do
      create(:auction, :complete_and_successful)
    end
    let!(:running_auction) { create(:auction, :running) }
    let!(:payment_needed) { create(:auction, :payment_needed) }
    let!(:rejected) { create(:auction, :rejected) }

    it 'should only return auctions where delivery is past due' do
      expect(query.delivery_past_due).to match_array([delivery_past_due])
    end
  end

  describe '#public_find' do
    let(:unpublished_auction) { create(:auction, :unpublished) }
    let(:published_auction) { create(:auction, :published) }

    it 'should not return an unpublished auction' do
      expect { query.public_find(unpublished_auction.id) }
        .to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'should return a published auction' do
      expect(query.public_find(published_auction.id)).to eq(published_auction)
    end
  end

  describe '#public_index' do
    it 'should only return published auctions' do
      _unpublished_auction = create(:auction, :unpublished)
      published_auction = create(:auction, :published)

      query = AuctionQuery.new

      expect(query.public_index).to match_array([published_auction])
    end
  end

  describe '#active_auction_count' do
    it 'returns number of available auctions' do
      _active_auction = create(:auction, :available)
      _inactive_auction = create(:auction, :closed)

      query = AuctionQuery.new

      expect(query.active_auction_count).to eq 1
    end
  end

  describe '#upcoming_auction_count' do
    it 'returns number of published future auctions' do
      _published_future = create(:auction, :future, :published)
      _published_current = create(:auction, :available, :published)
      _unpublished_future = create(:auction, :future, :unpublished)

      query = AuctionQuery.new

      expect(query.active_auction_count).to eq 1
    end
  end

  describe '#with_bid_from_user' do
    it 'returns auctions where the user has placed a bid' do
      auction = create(:auction, :with_bidders)
      bidder = auction.bids.first.bidder

      expect(AuctionQuery.new.with_bid_from_user(bidder.id)).to eq([auction])
    end

    it 'does not return auctions where the user has not bid' do
      create(:auction, :with_bidders)
      user = create(:user)

      expect(AuctionQuery.new.with_bid_from_user(user.id)).to eq([])
    end
  end
end
