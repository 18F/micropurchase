require 'rails_helper'

describe AuctionShowViewModel do
  describe '#nofollow_partial' do
    context 'when the auction is published' do
      it 'returns the null partial' do
        auction = create(:auction, :published)
        user = create(:user)

        view_model = AuctionShowViewModel.new(auction: auction, current_user: user)

        expect(view_model.nofollow_partial).to eq('components/null')
      end
    end

    context 'when the auction is unpublished' do
      it 'returns the nofollow partial' do
        auction = create(:auction, :unpublished)
        user = create(:user)

        view_model = AuctionShowViewModel.new(auction: auction, current_user: user)

        expect(view_model.nofollow_partial).to eq('components/nofollow')
      end
    end
  end

  describe '#bid_label' do
    it 'should show the winning bid amount and user when the auction has a winner' do
      auction = create(:auction, :closed, :with_bids)
      bid = WinningBid.new(auction).find
      name = bid.bidder.name
      user = create(:user)

      view_model = AuctionShowViewModel.new(auction: auction, current_user: user)

      expect(view_model.bid_label).to eq("Winning bid (#{name}): #{Currency.new(bid.amount)}")
    end

    it "should show the user's bid when the user is winning" do
      auction = create(:auction, :with_bids)
      bid = auction.bids.last
      user = bid.bidder
      view_model = AuctionShowViewModel.new(auction: auction, current_user: user)

      expect(view_model.bid_label).to eq("You have the lowest bid: #{Currency.new(bid.amount)}")
    end

    it 'should show the current bid when the auction has any bids' do
      auction = create(:auction, :with_bids)
      bid = WinningBid.new(auction).find
      user = create(:user)
      view_model = AuctionShowViewModel.new(auction: auction, current_user: user)

      expect(view_model.bid_label).to eq("Current low bid: #{Currency.new(bid.amount)} (#{bid.bidder.name})")
    end

    it "should show the starting price when auction hasn't started yet" do
      auction = create(:auction, :future, start_price: 1000)
      user = create(:user)
      view_model = AuctionShowViewModel.new(auction: auction, current_user: user)

      expect(view_model.bid_label).to eq("Starting price: $1,000.00")
    end

    it "should be blank when auction is sealed-bid and currently running" do
      auction = create(:auction, :with_bids, :sealed_bid, start_price: 2500)
      user = create(:user)
      view_model = AuctionShowViewModel.new(auction: auction, current_user: user)

      expect(view_model.bid_label).to eq("")
    end

    it "should show the user's bid when auction is sealed-bid and currently running and the user had bid" do
      auction = create(:auction, :with_bids, :sealed_bid, start_price: 2500)
      bid = auction.bids.first
      user = bid.bidder

      view_model = AuctionShowViewModel.new(auction: auction, current_user: user)

      expect(view_model.bid_label).to eq("Your bid: #{Currency.new(bid.amount)}")
    end

    it 'should be blank if auction had no bids' do
      auction = create(:auction, :closed)
      user = create(:user)
      view_model = AuctionShowViewModel.new(auction: auction, current_user: user)

      expect(view_model.bid_label).to be_blank
    end
  end
end
