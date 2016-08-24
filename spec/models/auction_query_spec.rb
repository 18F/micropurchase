require 'rails_helper'
describe AuctionQuery do
  let(:query) { AuctionQuery.new }

  describe '#complete_and_successful' do
    let(:complete_and_successful) do
      create(:auction, :complete_and_successful)
    end
    let!(:available_auction) { create(:auction, :available) }
    let!(:rejected_auction) { create(:auction, status: :rejected) }
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
    let!(:rejected_auction) { create(:auction, status: :rejected) }

    it 'should only return unpublished auctions' do
      expect(query.rejected).to match_array([rejected_auction])
    end
  end

  describe '#c2_payment_needed' do
    it 'returns auctions that are eligible for c2 payment' do
      _available_auction = create(:auction, :available)
      _payment_needed_other_pcard = create(
        :auction,
        purchase_card: :other,
        status: :accepted,
        accepted_at: Time.current
      )
      c2_payment_needed = create(
        :auction,
        purchase_card: :default,
        status: :accepted,
        accepted_at: Time.current
      )

      expect(query.c2_payment_needed).to match_array([c2_payment_needed])
    end
  end

  describe '#payment_needed' do
    it 'returns auctions that are accepted but not paid' do
      _available_auction = create(:auction, :available)
      payment_needed_other_pcard = create(
        :auction,
        purchase_card: :other,
        status: :accepted,
        accepted_at: Time.current
      )
      c2_payment_needed = create(
        :auction,
        purchase_card: :default,
        status: :accepted,
        accepted_at: Time.current
      )

      expect(query.payment_needed).to match_array(
        [payment_needed_other_pcard, c2_payment_needed]
      )
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

  describe '#needs_attention_count' do
    it 'returns the sum of unpublished, pending_delivery, pending_acceptance and payment_needed auctions' do
      _regular = create(:auction)
      _unpublished = create(:auction, :unpublished)
      _pending_delivery = create(:auction, :closed)
      _pending_acceptance = create(:auction, :evaluation_needed)
      _payment_needed = create(:auction, :payment_needed)

      query = AuctionQuery.new

      expect(query.needs_attention_count).to eq(4)
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
