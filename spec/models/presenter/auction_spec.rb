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
    let!(:bids) {
      [
        FactoryGirl.create(:bid, auction_id: ar_auction.id, amount: 20),
        FactoryGirl.create(:bid, auction_id: ar_auction.id, amount: 10)
      ]
    }

    it 'return the bid with the lowest amount' do
      expect(auction.current_bid).to eq(bids.last)
    end
  end

  describe '#current_bid when there are multiple bids with the same amount' do
    let!(:bids) {
      collection = [
        FactoryGirl.create(:bid, auction_id: ar_auction.id, amount: 10.00),
        FactoryGirl.create(:bid, auction_id: ar_auction.id, amount: 10.00),
        FactoryGirl.create(:bid, auction_id: ar_auction.id, amount: 10.00)
      ]
      collection[1].update_attribute(:created_at, (Time.now - 3.hours).utc)
      collection
    }

    it 'return the bid with the lowest amount' do
      expect(auction.current_bid).to eq(bids[1])
    end
  end

  describe '#available?' do
    context 'when the auction has expired' do
      let(:ar_auction) { FactoryGirl.create(:auction, :closed) }

      it 'should be false' do
        expect(auction.available?).to eq(false)
      end
    end

    context 'when the auction has not started yet' do
      let(:ar_auction) { FactoryGirl.create(:auction, :future) }

      it 'should be false' do
        expect(auction.available?).to eq(false)
      end
    end

    context 'when between dates' do
      let(:ar_auction) { FactoryGirl.create(:auction) }

      it 'should be false' do
        expect(auction.available?).to eq(true)
      end
    end
  end

  describe "#html_summary" do
    let(:summary) { nil }
    let(:auction) { Presenter::Auction.new(FactoryGirl.build(:auction,  summary: summary)) }

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
      let(:summary) { "First Header  | Second Header\n------------- | -------------\nContent Cell  | Content Cell\nContent Cell  | Content Cell\n" }

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
      let(:description) { "First Header  | Second Header\n------------- | -------------\nContent Cell  | Content Cell\nContent Cell  | Content Cell\n" }

      it 'should render a table element' do
        expect(auction.html_description).to match('<table>')
      end
    end
  end
end
