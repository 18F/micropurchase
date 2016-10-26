require 'rails_helper'

describe BiddingStatusPresenter::Available do
  describe 'bid_label' do
    context 'reverse auctions' do
      it "should show the user's bid when the user is winning" do
        bid = auction.bids.first
        user = bid.bidder
        presenter = BiddingStatusPresenter::Available.new(auction)

        expect(presenter.bid_label(user)).to eq("You have the lowest bid: #{Currency.new(bid.amount)}")
      end

      it 'should show the current bid when the auction has any bids' do
        bid = WinningBid.new(auction).find
        user = create(:user)
        presenter = BiddingStatusPresenter::Available.new(auction)

        expect(presenter.bid_label(user)).to eq("Current low bid: #{Currency.new(bid.amount)} (#{bid.bidder.name})")
      end

      it "should show an empty string when the auction has no bids" do
        auction = create(:auction, :available)
        user = create(:user)
        presenter = BiddingStatusPresenter::Available.new(auction)

        expect(presenter.bid_label(user)).to eq("")
      end
    end

    context 'sealed-bid auctions' do
      it 'should be blank when the auction is running' do
        auction = create(:auction, :with_bids, :sealed_bid, start_price: 2500)
        user = create(:user)
        presenter = BiddingStatusPresenter::Available.new(auction)

        expect(presenter.bid_label(user)).to eq("")
      end

      it "should show the user's bid if the user has bid" do
        auction = create(:auction, :with_bids, :sealed_bid, start_price: 2500)
        bid = auction.bids.first
        user = bid.bidder
        presenter = BiddingStatusPresenter::Available.new(auction)

        expect(presenter.bid_label(user)).to eq("Your bid: #{Currency.new(bid.amount)}")
      end
    end
  end

  describe '#tag_data_value_status' do
    it "has a twitter status data value with human readable time expression" do
      presenter = BiddingStatusPresenter::Available.new(auction)
      expect(presenter.tag_data_value_status).to eq("2 days left")
    end
  end

  describe '#tag_data_label_2' do
    it "has a twitter second label that indicates bidding is open" do
      presenter = BiddingStatusPresenter::Available.new(auction)
      expect(presenter.tag_data_label_2).to eq("Bidding")
    end
  end

  describe '#tag_data_value_2' do
    it "has some weird value associated with the bidding label" do
      presenter = BiddingStatusPresenter::Available.new(auction)
      expect(presenter.tag_data_value_2).to eq("$3,000.00 - 1 bids")
    end
  end

  describe '#relative_time' do
    it 'returns time remaining' do
      presenter = BiddingStatusPresenter::Available.new(auction)
      expect(presenter.relative_time).to eq("Closes #{DcTimePresenter.new(auction.ended_at).relative_time}")
    end
  end

  def auction
    @_auction ||= create(
      :auction,
      :available,
      start_price: 3500,
      bids: [create(:bid, amount: 3000)]
    )
  end
end
