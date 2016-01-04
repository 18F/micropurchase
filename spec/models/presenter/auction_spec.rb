require 'rails_helper'

RSpec.describe Presenter::Auction do
  let(:auction) { Presenter::Auction.new(ar_auction) }
  let(:ar_auction) { FactoryGirl.create(:auction) }

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

  describe '#available?' do
    context 'when the auction has expired' do
      let(:ar_auction) { FactoryGirl.create(:auction, :closed) }

      it 'should be false' do
        expect(auction).to_not be_available
      end
    end

    context 'when the auction has not started yet' do
      let(:ar_auction) { FactoryGirl.create(:auction, :future) }

      it 'should be false' do
        expect(auction).to_not be_available
      end
    end

    context 'when between dates' do
      let(:ar_auction) { FactoryGirl.create(:auction) }

      it 'should be false' do
        expect(auction).to be_available
      end
    end
  end

  describe '#over?' do
    context 'when the auction has expired' do
      let(:ar_auction) { FactoryGirl.create(:auction, :closed) }

      it 'should be true' do
        expect(auction).to be_over
      end
    end

    context 'when the auction is still running' do
      let(:ar_auction) { FactoryGirl.create(:auction) }

      it 'should not be true' do
        expect(auction).to_not be_over
      end
    end

    context 'when the auction has not started' do
      let(:ar_auction) { FactoryGirl.create(:auction, :future) }

      it 'should be false' do
        expect(auction).to_not be_over
      end
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
end
