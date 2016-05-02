require 'rails_helper'

describe Rules::SealedBid do
  let(:ar_auction) { create(:auction, :single_bid, :with_bidders) }
  let(:auction) { AuctionPresenter.new(ar_auction) }
  subject { Rules::SealedBid.new(auction) }

  describe 'winning_bid' do
    context 'if the auction if open' do
      it 'returns a NullBidPresenter object' do
        expect(subject.winning_bid).to be_a(NullBidPresenter)
      end
    end

    context 'if the auction is over' do
      let(:ar_auction) { create(:auction, :single_bid, :with_bidders, :closed) }
      it "returns the auction's lowest bid" do
        expect(subject.winning_bid).to eq(auction.lowest_bid)
      end
    end
  end

  describe 'veiled_bids' do
    context 'if the auction is open' do
      context 'if the user made a bid' do
        let(:user) { auction.bids.first.bidder }

        it "should return only the user's bid" do
          expect(subject.veiled_bids(user)).to eq([auction.bids.first])
        end
      end

      context 'if the user did not bid' do
        let(:user) { create(:user) }

        it 'should return an empty array' do
          expect(subject.veiled_bids(user)).to eq([])
        end
      end
    end

    context 'if the auction is over' do
      let(:ar_auction) { create(:auction, :single_bid, :with_bidders, :closed) }
      let(:user) { create(:user) }

      it 'should return all bids' do
        expect(subject.veiled_bids(user)).to eq(auction.bids)
      end
    end
  end

  describe 'highlighted_bid' do
    context 'when the auction is over' do
      let(:ar_auction) { create(:auction, :single_bid, :with_bidders, :closed) }
      let(:user) { create(:user) }

      it 'should return the lowest bid' do
        expect(subject.highlighted_bid(user)).to eq(auction.lowest_bid)
      end
    end

    context 'when the auction is running' do
      let(:ar_auction) { create(:auction, :single_bid, :with_bidders) }

      context 'when the user has placed a bid' do
        let(:user) { auction.bids.first.bidder }

        it "should return the user's bid" do
          expect(subject.highlighted_bid(user)).to eq(auction.bids.first)
        end
      end

      context 'when the user has not placed a bid' do
        let(:user) { create(:user) }

        it 'should return a NullBidPresenter object' do
          expect(subject.highlighted_bid(user)).to be_a(NullBidPresenter)
        end
      end
    end
  end

  describe 'user_can_bid?' do
    let(:ar_auction) { create(:auction, :single_bid, :with_bidders) }

    context 'when the user has placed a bid' do
      let(:user) { auction.bids.first.bidder }
      it 'should return false' do
        expect(subject.user_can_bid?(user)).to be_falsey
      end
    end

    context 'when the user has not placed a bid' do
      let(:user) { create(:user, sam_status: :sam_accepted) }

      it 'should return true' do
        expect(subject.user_can_bid?(user)).to be_truthy
      end
    end
  end

  describe 'max_allowed_bid' do
    it 'should return BID_INCREMENT below the start price' do
      expect(subject.max_allowed_bid).to eq(auction.start_price - PlaceBid::BID_INCREMENT)
    end
  end

  describe 'show_bids?' do
    it 'should return true if the auction is closed' do
      expect(subject.show_bids?).to eq(!auction.available?)
    end
  end
end
