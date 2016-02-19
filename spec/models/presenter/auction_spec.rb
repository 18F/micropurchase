require 'rails_helper'

RSpec.describe Presenter::Auction do
  let(:ar_auction) { FactoryGirl.create(:auction) }
  let(:auction) { Presenter::Auction.new(ar_auction) }
  let(:user) { FactoryGirl.create(:user) }

  describe '#veiled_bids' do
    context 'when a single bid auction is still running' do
      let(:ar_auction) { FactoryGirl.create(:auction, :single_bid_with_tie, :running) }

      it 'should return no bids' do
        expect(auction.veiled_bids(user)).to match_array([])
      end
    end

    context 'when a single bid auction is still running and the user has placed a bid' do
      let(:ar_auction) { FactoryGirl.create(:auction, :single_bid_with_tie, :running) }
      let(:last_bid) { auction.bids.last }
      let(:last_bidder) { last_bid.bidder }

      it 'should return only the bid placed by the user' do
        expect(auction.veiled_bids(last_bidder).map(&:id)).to match_array([last_bid].map(&:id))
      end
    end

    context 'when a single bid auction has closed' do
      let(:ar_auction) { FactoryGirl.create(:auction, :single_bid_with_tie, :closed) }

      it 'should return all bids associated with the auction' do
        expect(auction.veiled_bids(user).map(&:id)).to match_array(auction.bids.map(&:id))
      end
    end

    context 'when a multi-bid auction is still running' do
      let(:ar_auction) { FactoryGirl.create(:auction, :multi_bid, :with_bidders, :running) }

      it 'should return all bids associated with the auction' do
        expect(auction.veiled_bids(user).map(&:id)).to match_array(auction.bids.map(&:id))
      end
    end

    context 'when a single-bid auction has closed' do
      let(:ar_auction) { FactoryGirl.create(:auction, :multi_bid, :with_bidders, :closed) }

      it 'should return all bids associated with the auction' do
        expect(auction.veiled_bids(user).map(&:id)).to match_array(auction.bids.map(&:id))
      end
    end
  end

  describe '#winning_bid' do
    let(:lowest_bid_amount) { auction.bids.sort_by {|a| a.amount}.first.amount }

    context 'when the auction is a single bid auction' do
      let(:ar_auction) { FactoryGirl.create(:auction, :single_bid_with_tie, :closed) }
      let(:earliest_bidder) { auction.bids.sort_by {|a| a.created_at}.first }

      it 'should select the earliest bid in the event of a tie' do
        expect(auction.winning_bid.id).to eq(earliest_bidder.id)
      end

      it 'should select the lowest bid' do
        expect(auction.winning_bid.amount).to eq(lowest_bid_amount)
      end
    end

    context 'when the auction is a multi bid auction' do
      let(:ar_auction) { FactoryGirl.create(:auction, :multi_bid, :with_bidders) }

      it 'should select the lowest bid' do
        expect(auction.winning_bid.amount).to eq(lowest_bid_amount)
      end
    end
  end

  describe '#current_bid when there are no bids' do
    it 'return a null bid' do
      expect(auction.current_bid).to be_a(Presenter::Bid::Null)
    end
  end

  describe '#current_bid when there is only one bid in the timeframe' do
    let!(:bid) { FactoryGirl.create(:bid, auction_id: ar_auction.id) }

    it 'return that bid' do
      expect(auction.current_bid).to eq(bid)
    end
  end

  describe '#current_bid when there are multiple bids of different amounts' do
    let!(:bids) do
      [
        FactoryGirl.create(:bid, auction_id: ar_auction.id, amount: 20),
        FactoryGirl.create(:bid, auction_id: ar_auction.id, amount: 10)
      ]
    end

    it 'return the bid with the lowest amount' do
      expect(auction.current_bid).to eq(bids.last)
    end
  end

  describe '#current_bid when there are multiple bids with the same amount' do
    let!(:bids) do
      collection = [
        FactoryGirl.create(:bid, auction_id: ar_auction.id, amount: 10.00),
        FactoryGirl.create(:bid, auction_id: ar_auction.id, amount: 10.00),
        FactoryGirl.create(:bid, auction_id: ar_auction.id, amount: 10.00)
      ]
      collection[1].update_attribute(:created_at, (Time.now - 3.hours).utc)
      collection
    end

    it 'return the bid with the lowest amount' do
      expect(auction.current_bid).to eq(bids[1])
    end
  end

  describe '#user_is_winning_bidder?' do
    let(:ar_auction) { FactoryGirl.create(:auction, :with_bidders) }

    context 'when the user is currently the winner' do
      let(:bidder) { auction.bids.first.bidder }

      it 'should return true' do
        expect(auction.user_is_winning_bidder?(bidder)).to be_truthy
      end
    end

    context 'when the user is not the current winner' do
      let(:bidder) { auction.bids.last.bidder }

      it 'should return false' do
        expect(auction.user_is_winning_bidder?(bidder)).to be_falsey
      end
    end
  end

  describe '#user_is_bidder?' do
    let(:ar_auction) { FactoryGirl.create(:auction, :with_bidders) }

    context 'when the user has placed a bid on the project' do
      let(:bidder) { auction.bids.last.bidder }

      it 'should return true' do
        expect(auction.user_is_bidder?(bidder)).to be_truthy
      end
    end

    context 'when the user has not placed a bid on the project' do
      let(:bidder) { FactoryGirl.create(:user) }

      it 'should return false' do
        expect(auction.user_is_bidder?(bidder)).to be_falsey
      end
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

  describe "#in_reverse_chron_order" do
    it 'should arrange auctions in order of descending end times' do
      auction1 = FactoryGirl.create(:auction, end_datetime: Time.now)
      auction2 = FactoryGirl.create(:auction, end_datetime: 2.days.from_now)
      auction3 = FactoryGirl.create(:auction, end_datetime: 3.days.ago)

      expect(Auction.in_reverse_chron_order).to eq([auction2, auction1, auction3])
    end
  end

  describe "#html_summary" do
    let(:summary) { nil }
    let(:auction) { Presenter::Auction.new(FactoryGirl.build(:auction, summary: summary)) }

    it 'should return an empty string if the summary is blank' do
      expect(auction.html_summary).to be_blank
    end

    context 'bold text' do
      let(:summary) { 'This is **bold** text' }

      it 'should render correctly' do
        expect(auction.html_summary).to match("<strong>bold</strong>")
      end
    end

    context 'italicized text' do
      let(:summary) { 'This is _italic_ text' }

      it 'should render correctly' do
        expect(auction.html_summary).to match('<em>italic</em>')
      end
    end

    context 'autolinks' do
      let(:summary) { 'Please visit http://18f.gov anytime' }

      it 'should render correctly' do
        expect(auction.html_summary).to match('<a href="http://18f.gov">http://18f.gov</a>')
      end
    end

    context 'ignoring underscores in words' do
      let(:summary) { 'This_is_a_test' }

      it 'should not render as italicized' do
        expect(auction.html_summary).to_not match('<em>')
      end
    end

    context 'table rendering' do
      let(:summary) { "First Header|Second Header\n------------- | -------------\nContent Cell  | Content Cell\n" }

      it 'should render a table element' do
        expect(auction.html_summary).to match('<table>')
      end
    end
  end

  describe '#html_description' do
    let(:description) { nil }
    let(:auction) { Presenter::Auction.new(FactoryGirl.build(:auction, description: description)) }

    it 'should return an empty string if the description is blank' do
      expect(auction.html_description).to be_blank
    end

    context 'bold text' do
      let(:description) { 'This is **bold** text' }

      it 'should render correctly' do
        expect(auction.html_description).to match("<strong>bold</strong>")
      end
    end

    context 'italicized text' do
      let(:description) { 'This is _italic_ text' }

      it 'should render correctly' do
        expect(auction.html_description).to match('<em>italic</em>')
      end
    end

    context 'autolinks' do
      let(:description) { 'Please visit http://18f.gov anytime' }

      it 'should render correctly' do
        expect(auction.html_description).to match('<a href="http://18f.gov">http://18f.gov</a>')
      end
    end

    context 'ignoring underscores in words' do
      let(:description) { 'This_is_a_test' }

      it 'should not render as italicized' do
        expect(auction.html_description).to_not match('<em>')
      end
    end

    context 'table rendering' do
      let(:description) { "First Header|Second Header\n------------- | -------------\nContent Cell  | Content Cell\n" }

      it 'should render a table element' do
        expect(auction.html_description).to match('<table>')
      end
    end
  end

  describe 'user_bids' do
    context 'when the user has not made a bid' do
      let(:user) { FactoryGirl.create(:user) }
      let(:ar_auction) { FactoryGirl.create(:auction, :single_bid, :running, :with_bidders) }

      it 'should return an empty array' do
        expect(auction.user_bids(user)).to eq([])
      end

      it 'should return nil for the lowest_user_bid' do
        expect(auction.lowest_user_bid(user)).to be_nil
      end

      it 'should return nil for the lowest_user_bid_amount' do
        expect(auction.lowest_user_bid_amount(user)).to be_nil
      end
    end

    context 'when the user has made a bid' do
      context 'for a single-bid auction' do
        let(:user1) { FactoryGirl.create(:user) }
        let(:user2) { FactoryGirl.create(:user) }
        let(:ar_auction) { FactoryGirl.create(:auction, :single_bid, :running, bidder_ids: [user1.id, user2.id]) }
        let(:auction) { Presenter::Auction.new(ar_auction) }
        let(:user1_bid) { auction.bids.detect {|b| b.bidder_id == user1.id }.amount }

        it 'should return an array with 1 bid' do
          out = auction.user_bids(user1)
          expect(out).to be_an Array
          expect(out.size).to eq(1)
          expect(out.first.bidder).to eq(user1)
          expect(out.first.amount).to eq(user1_bid)
        end

        it 'should return the bid for lowest_user_bid' do
          bid = auction.lowest_user_bid(user1)
          expect(bid.bidder).to eq(user1)
          expect(bid.amount).to eq(user1_bid)
        end

        it 'should return the amount for the lowest_user_bid_amount' do
          expect(auction.lowest_user_bid_amount(user1)).to eq(user1_bid)
        end
      end

      context 'for a multi-bid auction' do
        let(:user1) { FactoryGirl.create(:user) }
        let(:user2) { FactoryGirl.create(:user) }
        let(:ar_auction) { FactoryGirl.create(:auction, :multi_bid, :running, bidder_ids: [user1.id, user2.id, user1.id, user2.id, user1.id]) }
        let(:auction) { Presenter::Auction.new(ar_auction) }
        let(:user1_bid) { auction.bids.sort_by(&:amount).detect {|b| b.bidder_id == user1.id }.amount }

        it 'should return an array with all user bids' do
          out = auction.user_bids(user1)
          expect(out).to be_an Array
          expect(out.size).to eq(3)
          expect(out.first.bidder).to eq(user1)
        end

        it 'should return the lowest bid for lowest_user_bid' do
          bid = auction.lowest_user_bid(user1)
          expect(bid.bidder).to eq(user1)
          expect(bid.amount).to eq(user1_bid)
        end

        it 'should return the lowest amount for the lowest_user_bid_amount' do
          expect(auction.lowest_user_bid_amount(user1)).to eq(user1_bid)
        end
      end
    end
  end
end
