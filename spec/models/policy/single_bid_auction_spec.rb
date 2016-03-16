require 'rails_helper'

RSpec.describe Policy::SingleBidAuction, type: :model do
  let(:ar_auction) { FactoryGirl.create(:auction, :single_bid, :with_bidders) }
  let(:pr_auction) { Presenter::Auction.new(ar_auction) }
  let(:user) { FactoryGirl.create(:user) }
  let(:auction) { Policy::SingleBidAuction.new(pr_auction, user) }
  let(:user2) { FactoryGirl.create(:user) }
  let(:user3) { FactoryGirl.create(:user) }

  describe 'user_can_bid?' do
    context 'when the user is not logged in' do
      let(:user) { nil }

      it 'should return false' do
        skip('might be true to show bid button')
        expect(auction.user_can_bid?).to be_falsey
      end
    end

    context 'when the user does not have a SAM account' do
      let(:user) { FactoryGirl.create(:user, sam_account: false) }

      it 'should return false' do
        expect(auction.user_can_bid?).to be_falsey
      end
    end

    context 'when the auction is closed' do
      let(:ar_auction) { FactoryGirl.create(:auction, :single_bid, :closed) }

      it 'should return false' do
        expect(auction.user_can_bid?).to be_falsey
      end
    end

    context 'when the user has not bid on the auction' do
      it 'should return true' do
        expect(auction.user_can_bid?).to be_truthy
      end
    end

    context 'when the user has bid already' do
      let(:ar_auction) { FactoryGirl.create(:auction, :single_bid, :with_bidders, bidder_ids: [user.id]) }

      it 'should return false' do
        expect(auction.user_can_bid?).to be_falsey
      end
    end
  end

  describe 'bids?' do
    context 'when the auction is still running' do
      context 'the user has placed a bid' do
        let(:ar_auction) { FactoryGirl.create(:auction, :single_bid, :with_bidders, bidder_ids: [user.id]) }

        it 'should return true' do
          expect(auction.bids?).to be_truthy
        end
      end

      context 'the user has not placed a bid' do
        it 'should return false' do
          expect(auction.bids?).to be_falsey
        end
      end
    end

    context 'when the auction is closed' do
      context 'there are bids in the auction' do
        let(:ar_auction) { FactoryGirl.create(:auction, :single_bid, :with_bidders, :closed) }

        it 'should return truthy' do
          expect(auction.bids?).to be_truthy
        end
      end

      context 'there are no bids on the auction' do
        let(:ar_auction) { FactoryGirl.create(:auction, :single_bid, :closed) }

        it 'should return false' do
          expect(auction.bids?).to be_falsey
        end
      end
    end
  end

  describe 'bid_count' do
    context 'when the auction is still running' do
      context 'when the user has placed a bid' do
        let(:ar_auction) { FactoryGirl.create(:auction,
                                              :single_bid,
                                              :with_bidders,
                                              bidder_ids: [user3.id, user.id, user2.id]) }

        it 'should return 1' do
          expect(auction.bid_count).to eq(1)
        end
      end

      context 'when the user has not placed a bid' do
        it 'should return 0' do
          expect(auction.bid_count).to eq(0)
        end
      end
    end

    context 'when the auction is over' do
      let(:ar_auction) { FactoryGirl.create(:auction, :single_bid, :with_bidders, :closed) }

      it 'should return the total number of bids' do
        expect(auction.bid_count).to eq(pr_auction.bid_count)
      end
    end
  end

  describe 'highlighted_bid' do
    context 'when the auction is open' do
      context 'when the user has made a bid' do
        let(:ar_auction) { FactoryGirl.create(:auction, :single_bid, :with_bidders, bidder_ids: [user.id, user2.id]) }
        it "should be the user's bid" do
          bid = pr_auction.bids.detect {|b| b.bidder_id == user.id }
          expect(bid).to_not be_nil
          expect(auction.highlighted_bid).to eq(bid)
        end

        it 'should return a Presenter::Bid object' do
          expect(auction.highlighted_bid).to be_a(Presenter::Bid)
        end
      end

      context 'when the user has not made a bid' do
        it 'should be nil' do
          expect(auction.highlighted_bid).to be_nil
        end
      end
    end

    context 'when the auction is closed' do
      let(:ar_auction) { FactoryGirl.create(:auction, :single_bid, :with_bidders, :closed) }

      it 'should be the winning bid' do
        expect(auction.highlighted_bid).to eq(auction.winning_bid)
      end
    end
  end

  describe 'winning_bid' do
    context 'when the auction is still running' do
      it 'should return nil' do
        expect(auction.winning_bid).to be_a Presenter::Bid::Null
      end
    end

    context 'when the auction is over' do
      let(:ar_auction) { FactoryGirl.create(:auction, :single_bid, :with_bidders, :closed) }

      it 'should return the lowest bid' do
        bid = pr_auction.bids.sort_by(&:amount).first
        expect(auction.winning_bid).to eq(bid)
        expect(auction.bid_is_winner?(bid)).to be_truthy
      end

      context 'when there is a tie for the lowest bid' do
        it 'should return the earliest one' do
          lowest_bid = Presenter::Bid.new(ar_auction.bids.sort_by(&:amount).first)
          user_bid = ar_auction.bids.create(bidder_id: user.id,
                                            amount: lowest_bid.amount,
                                            created_at: lowest_bid.created_at + 10.seconds)

          expect(auction.winning_bid).to eq(lowest_bid)
          expect(auction.bid_is_winner?(lowest_bid)).to be_truthy
          expect(auction.bid_is_winner?(user_bid)).to be_falsey
        end
      end
    end
  end

  describe 'is_winner?' do
    context 'when the auction is running' do
      let(:ar_auction) { FactoryGirl.create(:auction, :single_bid, :with_bidders, bidder_ids: [user2.id, user.id]) }

      it 'should return false for bid_is_winner?' do
        bid = Presenter::Bid.new(ar_auction.bids.detect {|b| b.bidder_id = user.id})
        expect(auction.bid_is_winner?(bid)).to be_falsey
      end

      it 'should return false for user_is_winner?' do
        expect(auction.user_is_winner?).to be_falsey
      end
    end

    context 'when the auction is over' do
      context 'the user has the lowest bid' do
        let(:ar_auction) { FactoryGirl.create(:auction, :single_bid, :closed, :with_bidders, bidder_ids: [user2.id, user.id]) }

        it 'should return true for bid_is_winner?' do
          bid = Presenter::Bid.new(ar_auction.bids.detect {|b| b.bidder_id == user.id})
          expect(auction.bid_is_winner?(bid)).to be_truthy
        end

        it 'should return true for user_is_winner?' do
          expect(auction.user_is_winner?).to be_truthy
        end

      end

      context 'the user does not have the lowest bid' do
        let(:ar_auction) { FactoryGirl.create(:auction, :single_bid, :closed, :with_bidders, bidder_ids: [user.id, user2.id]) }

        it 'should return false for bid_is_winner?' do
          bid = Presenter::Bid.new(ar_auction.bids.detect {|b| b.bidder_id = user.id})
          expect(auction.bid_is_winner?(bid)).to be_falsey
        end

        it 'should return false for user_is_winner?' do
          expect(auction.user_is_winner?).to be_falsey
        end
      end
    end
  end

  describe 'displayed_bids' do
    context 'when the auction is still running' do
      context 'the user has made a bid' do
        let(:ar_auction) { FactoryGirl.create(:auction,
                                              :single_bid,
                                              :with_bidders,
                                              bidder_ids: [user.id, user2.id, user3.id]) }

        it "should return the user's bid in an array" do
          bid = pr_auction.bids.detect {|b| b.bidder_id == user.id }
          expect(bid).to_not be_nil
          expect(auction.displayed_bids).to eq([bid])
        end
      end

      context 'the user has not made a bid' do
        it 'should return an empty array' do
          expect(auction.displayed_bids).to eq([])
        end
      end
    end

    context 'when the auction is over' do
      let(:ar_auction) { FactoryGirl.create(:auction, :single_bid, :with_bidders, :closed) }

      it 'should just return a list of bids' do
        expect(auction.displayed_bids).to eq(pr_auction.bids)
      end
    end
  end

  describe 'user_bids' do
    context 'when the user has not made a bid' do
      let(:ar_auction) { FactoryGirl.create(:auction, :multi_bid, :running, :with_bidders) }

      it 'should return an empty array' do
        expect(auction.user_bids).to eq([])
      end

      it 'should return Presenter::Bid::Null for the lowest_user_bid' do
        expect(auction.lowest_user_bid).to be_a Presenter::Bid::Null
      end

      it 'should return nil for the lowest_user_bid_amount' do
        expect(auction.lowest_user_bid_amount).to be_nil
      end

      it 'should return false for user_is_bidder?' do
        expect(auction.user_is_bidder?).to be_falsey
      end
    end

    context 'when the user has made a bid' do
      let(:user2) { FactoryGirl.create(:user) }
      let(:ar_auction) { FactoryGirl.create(:auction, :single_bid, :running, bidder_ids: [user.id, user2.id]) }
      let(:user_bid) { ar_auction.bids.detect {|b| b.bidder_id == user.id }.amount }

      it 'should return an array with 1 bid' do
        out = auction.user_bids
        expect(out).to be_an Array
        expect(out.size).to eq(1)
        expect(out.first.bidder).to eq(user)
        expect(out.first.amount).to eq(user_bid)
      end

      it 'should return the bid for lowest_user_bid' do
        bid = auction.lowest_user_bid
        expect(bid).to be_a Presenter::Bid
        expect(bid.bidder).to eq(user)
        expect(bid.amount).to eq(user_bid)
      end

      it 'should return the amount for the lowest_user_bid_amount' do
        expect(auction.lowest_user_bid_amount).to eq(user_bid)
      end

      it 'should return truthy for user_is_bidder?' do
        expect(auction.user_is_bidder?).to be_truthy
      end
    end
  end

  describe 'max_possible_bid_amount' do
    it 'should always be the auction start price' do
      expect(auction.max_possible_bid_amount).to eq(pr_auction.start_price)
    end
  end

  context 'min_possible_bid_amount' do
    it 'should always be $1' do
      expect(auction.min_possible_bid_amount).to eq(1)
    end
  end
end
