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
end
