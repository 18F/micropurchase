require 'rails_helper'

RSpec.describe ViewModel::Auction, type: :model do
  let(:ar_auction) { FactoryGirl.create(:auction) }
  let(:user) { FactoryGirl.create(:user) }
  let(:auction) { ViewModel::Auction.new(user, ar_auction) }

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

      context 'when the user does not have a SAM account' do
        let(:user) { FactoryGirl.create(:user, sam_account: false) }

        it 'should return false for show_bid_button?' do
          expect(auction.show_bid_button?).to be_falsey
        end

        it 'should return false for user_can_bid?' do
          expect(auction.user_can_bid?).to be_falsey
        end
      end

      context 'when the auction is open and the user has not placed a bid' do
        let(:ar_auction) { FactoryGirl.create(:auction, :single_bid) }

        it 'should return true for show_bid_button?' do
          expect(auction.show_bid_button?).to be_truthy
        end

        it 'should return true for user_can_bid?' do
          expect(auction.user_can_bid?).to be_truthy
        end
      end

      context 'when the user has already placed a bid' do
        let(:ar_auction) { FactoryGirl.create(:auction, :single_bid, :with_bidders, bidder_ids: [user.id]) }

        it 'should return false for show_bid_button?' do
          expect(auction.show_bid_button?).to be_falsey
        end

        it 'should return false for user_can_bid?' do
          expect(auction.user_can_bid?).to be_falsey
        end
      end

      context 'when the auction is over' do
        let(:ar_auction) { FactoryGirl.create(:auction, :single_bid, :with_bidders, :closed) }

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
        let(:user) { FactoryGirl.create(:user, sam_account: false) }

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

      context 'when the auction is over' do
        let(:ar_auction) { FactoryGirl.create(:auction, :with_bidders, :closed) }

        it 'should return false for show_bid_button?' do
          expect(auction.show_bid_button?).to be_falsey
        end

        it 'should return false for user_can_bid?' do
          expect(auction.user_can_bid?).to be_falsey
        end
      end
    end
  end
end
