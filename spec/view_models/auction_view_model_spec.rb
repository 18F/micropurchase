require 'rails_helper'

describe AuctionViewModel do
  let(:ar_auction) { create(:auction) }
  let(:user) { create(:user, sam_status: :sam_accepted) }
  let(:auction) { AuctionViewModel.new(user, ar_auction) }

  describe 'bid status checks' do
    context 'for a single-bid auction' do
      context 'when the user is not logged in' do
        let(:user) { nil }

        it 'should return true for show_bid_button?' do
          expect(auction.show_bid_button?).to be_truthy
        end

        it 'should return false for user_can_bid?' do
          expect(auction.user_can_bid?).to be_falsey
        end
      end

      context 'when the user does not have a verified SAM account' do
        let(:user) { create(:user, sam_status: :sam_pending) }

        it 'should return false for show_bid_button?' do
          expect(auction.show_bid_button?).to be_falsey
        end

        it 'should return false for user_can_bid?' do
          expect(auction.user_can_bid?).to be_falsey
        end
      end

      context 'when the auction is open and the user has not placed a bid' do
        let(:ar_auction) { create(:auction, :single_bid) }

        it 'should return true for show_bid_button?' do
          expect(auction.show_bid_button?).to be_truthy
        end

        it 'should return true for user_can_bid?' do
          expect(auction.user_can_bid?).to be_truthy
        end
      end

      context 'when the user has already placed a bid' do
        let(:ar_auction) { create(:auction, :single_bid, :with_bidders, bidder_ids: [user.id]) }

        it 'should return false for show_bid_button?' do
          expect(auction.show_bid_button?).to be_falsey
        end

        it 'should return false for user_can_bid?' do
          expect(auction.user_can_bid?).to be_falsey
        end
      end

      context 'when the auction is over' do
        let(:ar_auction) { create(:auction, :single_bid, :with_bidders, :closed) }

        it 'should return false for show_bid_button?' do
          expect(auction.show_bid_button?).to be_falsey
        end

        it 'should return false for user_can_bid?' do
          expect(auction.user_can_bid?).to be_falsey
        end
      end
    end

    context 'for a multi-bid auction' do
      context 'when the user is not logged in' do
        let(:user) { nil }

        it 'should return true for show_bid_button?' do
          expect(auction.show_bid_button?).to be_truthy
        end

        it 'should return false for user_can_bid?' do
          expect(auction.user_can_bid?).to be_falsey
        end
      end

      context 'when the user does not have a SAM account' do
        let(:user) { create(:user, sam_status: :sam_pending) }

        it 'should return false for show_bid_button?' do
          expect(auction.show_bid_button?).to be_falsey
        end

        it 'should return false for user_can_bid?' do
          expect(auction.user_can_bid?).to be_falsey
        end
      end

      context 'when the auction is open' do
        it 'should return true for show_bid_button?' do
          expect(auction.show_bid_button?).to be_truthy
        end

        it 'should return true for user_can_bid?' do
          expect(auction.user_can_bid?).to be_truthy
        end
      end
    end
  end

  describe '#user_is_winning_bidder?' do
    let(:ar_auction) { create(:auction, :with_bidders) }
    let(:bids) { ar_auction.bids.sort_by(&:amount) }
    let(:auction) { AuctionViewModel.new(bidder, ar_auction) }

    context 'when the user is currently the winner' do
      let(:bidder) { bids.first.bidder }

      it 'should return true' do
        expect(auction.user_is_winning_bidder?).to be_truthy
      end
    end

    context 'when the user is not the current winner' do
      let(:bidder) { bids.last.bidder }

      it 'should return false' do
        expect(auction.user_is_winning_bidder?).to be_falsey
      end
    end
  end

  describe '#user_is_bidder?' do
    let(:ar_auction) { create(:auction, :with_bidders) }
    let(:bids) { ar_auction.bids.sort_by(&:amount) }
    let(:auction) { AuctionViewModel.new(bidder, ar_auction) }

    context 'when the user has placed a bid on the project' do
      let(:bidder) { bids.last.bidder }

      it 'should return true' do
        expect(auction.user_is_bidder?).to be_truthy
      end
    end

    context 'when the user has not placed a bid on the project' do
      let(:bidder) { create(:user) }

      it 'should return false' do
        expect(auction.user_is_bidder?).to be_falsey
      end
    end
  end

  describe 'user_bids' do
    context 'when the user has not made a bid' do
      let(:user) { create(:user) }
      let(:ar_auction) { create(:auction, :single_bid, :running, :with_bidders) }

      it 'should return an empty array' do
        expect(auction.user_bids).to eq([])
      end

      it 'should return nil for the lowest_user_bid' do
        expect(auction.lowest_user_bid).to be_nil
      end

      it 'should return nil for the lowest_user_bid_amount' do
        expect(auction.lowest_user_bid_amount).to be_nil
      end
    end

    context 'when the user has made a bid' do
      context 'for a single-bid auction' do
        let(:user1) { create(:user) }
        let(:user2) { create(:user) }
        let(:ar_auction) { create(:auction, :single_bid, :running, bidder_ids: [user1.id, user2.id]) }
        let(:auction) { AuctionViewModel.new(user1, ar_auction) }
        let(:user1_bid) { auction.bids.detect { |b| b.bidder_id == user1.id }.amount }

        it 'should return an array with 1 bid' do
          out = auction.user_bids
          expect(out).to be_an Array
          expect(out.size).to eq(1)
          expect(out.first.bidder).to eq(user1)
          expect(out.first.amount).to eq(user1_bid)
        end

        it 'should return the bid for lowest_user_bid' do
          bid = auction.lowest_user_bid
          expect(bid.bidder).to eq(user1)
          expect(bid.amount).to eq(user1_bid)
        end

        it 'should return the amount for the lowest_user_bid_amount' do
          expect(auction.lowest_user_bid_amount).to eq(user1_bid)
        end
      end

      context 'for a multi-bid auction' do
        let(:user1) { create(:user) }
        let(:user2) { create(:user) }
        let(:ar_auction) { create(:auction, :multi_bid, :running, bidder_ids: [user1.id, user2.id, user1.id, user2.id, user1.id]) }
        let(:auction) { AuctionViewModel.new(user1, ar_auction) }
        let(:user1_bid) { auction.bids.sort_by(&:amount).detect {|b| b.bidder_id == user1.id }.amount }

        it 'should return an array with all user bids' do
          out = auction.user_bids
          expect(out).to be_an Array
          expect(out.size).to eq(3)
          expect(out.first.bidder).to eq(user1)
        end

        it 'should return the lowest bid for lowest_user_bid' do
          bid = auction.lowest_user_bid
          expect(bid.bidder).to eq(user1)
          expect(bid.amount).to eq(user1_bid)
        end

        it 'should return the lowest amount for the lowest_user_bid_amount' do
          expect(auction.lowest_user_bid_amount).to eq(user1_bid)
        end
      end
    end
  end
end
