require 'rails_helper'

describe Admin::AuctionShowViewModel do
  describe '#admin_data' do
    context 'auction for default purchase card' do
      it 'returns c2 proposal URL and c2 status and receipt fields' do
        auction = create(:auction, purchase_card: :default)
        user = create(:user)

        view_model = Admin::AuctionShowViewModel.new(auction: auction, current_user: user)
        data = view_model.admin_data

        expect(data).to have_key('C2 proposal URL')
        expect(data).to have_key('C2 approval status')
        expect(data).to have_key('Receipt URL')
      end
    end

    context 'auction for other purchase card' do
      it 'does not return c2 proposal URL or c2 status or receipt URL fields' do
        auction = create(:auction, purchase_card: :other)
        user = create(:user)

        view_model = Admin::AuctionShowViewModel.new(auction: auction, current_user: user)
        data = view_model.admin_data

        expect(data).not_to have_key('C2 proposal URL')
        expect(data).not_to have_key('C2 approval status')
        expect(data).not_to have_key('Receipt URL')
      end
    end
  end

  describe '#bid_label' do
    it 'should show the winning bid amount and user when the auction has a winner' do
      auction = create(:auction, :closed, :with_bids)
      bid = WinningBid.new(auction).find
      name = bid.bidder.name
      user = create(:user)

      view_model = Admin::AuctionShowViewModel.new(auction: auction, current_user: user)

      expect(view_model.bid_label).to eq("Winning bid (#{name}): #{Currency.new(bid.amount)}")
    end

    it 'should show the current bid when the auction has any bids' do
      auction = create(:auction, :with_bids)
      bid = WinningBid.new(auction).find
      user = create(:user)
      view_model = Admin::AuctionShowViewModel.new(auction: auction, current_user: user)

      expect(view_model.bid_label).to eq("Current low bid: #{Currency.new(bid.amount)} (#{bid.bidder.name})")
    end

    it "should show the starting price when auction hasn't started yet" do
      auction = create(:auction, :future, start_price: 1000)
      user = create(:user)
      view_model = Admin::AuctionShowViewModel.new(auction: auction, current_user: user)

      expect(view_model.bid_label).to eq("Starting price: $1,000.00")
    end

    it 'should be blank if auction had no bids' do
      auction = create(:auction, :closed)
      user = create(:user)
      view_model = Admin::AuctionShowViewModel.new(auction: auction, current_user: user)

      expect(view_model.bid_label).to be_blank
    end
  end
end
