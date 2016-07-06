require 'rails_helper'

describe Statistics::UniqueBiddersPerAuction do
  describe '#to_s' do
    it "returns average number of unique vendors who have submitted bids" do
      _auction_with_two_unique_bidders =
        create(:auction, :completed, bids: [create(:bid), create(:bid)])
      _auction_with_one_unique_bidder =
        create(:auction, :completed, bids: [create(:bid)])
      user = create(:user)
      auction_with_three_unique_bidders = create(:auction, :completed)
      create(:bid, auction: auction_with_three_unique_bidders, bidder: user)
      create(:bid, auction: auction_with_three_unique_bidders, bidder: user)
      create(:bid, auction: auction_with_three_unique_bidders)
      create(:bid, auction: auction_with_three_unique_bidders)

      expect(Statistics::UniqueBiddersPerAuction.new.to_s).to eq 2
    end
  end
end
