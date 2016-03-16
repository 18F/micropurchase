require 'rails_helper'

RSpec.describe Policy::Auction, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:ar_auction) { FactoryGirl.create(:auction) }
  let(:auction) { Policy::Auction.new(ar_auction, user) }
  let(:user2) { FactoryGirl.create(:user) }
  let(:user3) { FactoryGirl.create(:user) }

  describe 'lowest_bids' do
    context 'when there are no bids' do
      it 'should return an empty array' do
        expect(auction.send(:lowest_bids)).to eq([])
      end

      it 'should return nil for lowest_bid' do
        expect(auction.send(:lowest_bid)).to be_a Presenter::Bid::Null
      end
    end

    context 'when there are bids' do
      let!(:ar_bid1) { FactoryGirl.create(:bid, auction: ar_auction, amount: 80, created_at: Time.now) }
      let!(:ar_bid2) { FactoryGirl.create(:bid, auction: ar_auction, amount: 80, created_at: 10.minutes.ago) }

      it 'should return an Array of Presenter::Bid objects' do
        expect(auction.send(:lowest_bids)).to be_an Array
        expect(auction.send(:lowest_bids).first).to be_a Presenter::Bid
      end

      it 'should return the lowest bids in order of creation time' do
        expect(auction.send(:lowest_bids).first.created_at).to be < auction.send(:lowest_bids).last.created_at
      end

      it 'should return the first bid for lowest_bid' do
        b = auction.send(:lowest_bid)
        expect(b).to be_a Presenter::Bid
        expect(b.amount).to eq(80)
        expect(b).to eq(auction.send(:lowest_bids).first)
      end
    end
  end

  describe 'lowest_user_bid' do
    context 'when there are no bids' do
      it 'should return nil for lowest_user_bid' do
        expect(auction.lowest_user_bid).to be_a Presenter::Bid::Null
      end

      it 'should return nil for lowest_user_bid_amount' do
        expect(auction.lowest_user_bid_amount).to be_nil
      end
    end

    context 'when the user has not bid' do
      let(:ar_auction) { FactoryGirl.create(:auction, :with_bidders) }

      it 'should return nil for lowest_user_bid' do
        expect(auction.lowest_user_bid).to be_a Presenter::Bid::Null
      end

      it 'should return nil for lowest_user_bid_amount' do
        expect(auction.lowest_user_bid_amount).to be_nil
      end
    end

    context 'when the user has made a bid' do
      let(:ar_auction) { FactoryGirl.create(:auction, :with_bidders, bidder_ids: [user.id, user2.id, user3.id, user.id, user2.id]) }
      let(:lowest_user_bid) { ar_auction.bids.where(bidder_id: user.id).order('amount ASC').first }

      it 'should return an object for the lowest bid' do
        expect(auction.lowest_user_bid).to be_a Presenter::Bid
        expect(auction.lowest_user_bid.bidder).to eq(user)
        expect(auction.lowest_user_bid.amount).to eq(lowest_user_bid.amount)
      end

      it 'should return the lowest user bid amount' do
        expect(auction.lowest_user_bid_amount).to eq(lowest_user_bid.amount)
      end
    end
  end

  describe 'veiled_bids?' do
    context 'when the auction is running' do
      let(:ar_auction) { FactoryGirl.create(:auction, :with_bidders) }

      it 'should return true' do
        expect(auction.veiled_bids?).to be_truthy
      end

      it 'should assign each bidder to be veiled'
    end

    context 'when the auction is over' do
      let(:ar_auction) { FactoryGirl.create(:auction, :closed, :with_bidders) }

      it 'should return false' do
        expect(auction.veiled_bids?).to be_falsey
      end

      it 'should assign bidder to be unveiled'
    end
  end

  describe 'boolean methods' do
    context 'when the auction has expired' do
      let(:ar_auction) { FactoryGirl.create(:auction, :closed) }

      specify { expect(auction).to_not be_available }
      specify { expect(auction).to_not be_expiring }
      specify { expect(auction).to_not be_future }
      specify { expect(auction).to be_over }
    end

    context 'when the auction has not started yet' do
      let(:ar_auction) do
        FactoryGirl.create(:auction,
                           :future,
                           start_datetime: 1.hour.from_now,
                           end_datetime: 3.hours.from_now)
      end

      specify { expect(auction).to_not be_available }
      specify { expect(auction).to_not be_expiring }
      specify { expect(auction).to be_future }
      specify { expect(auction).to_not be_over }
    end

    context 'when the auction is happening' do
      let(:ar_auction) { FactoryGirl.create(:auction) }

      specify { expect(auction).to be_available }
      specify { expect(auction).to_not be_expiring }
      specify { expect(auction).to_not be_future }
      specify { expect(auction).to_not be_over }
    end

    context 'when the auction is closing soon' do
      let(:ar_auction) { FactoryGirl.create(:auction, :expiring) }

      specify { expect(auction).to be_available }
      specify { expect(auction).to be_expiring }
      specify { expect(auction).to_not be_future }
      specify { expect(auction).to_not be_over }
    end
  end
end
