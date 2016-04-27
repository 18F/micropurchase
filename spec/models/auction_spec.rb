require 'rails_helper'

describe Auction do
  describe "#lowest_bid" do
    context "multiple bids" do
      it "returns bid with lowest amount" do
        auction = FactoryGirl.create(:auction)
        low_bid = FactoryGirl.create(:bid, auction: auction, amount: 1)
        _high = FactoryGirl.create(:bid, auction: auction, amount: 10000)

        expect(auction.lowest_bid).to eq (low_bid)
      end
    end

    context "no bids" do
      it "returns nil" do
        auction = FactoryGirl.create(:auction)

        expect(auction.lowest_bid).to be_nil
      end
    end

    context "multiple bids with same amount" do
      it "returns first created bid" do
        auction = FactoryGirl.create(:auction)
        _second_bid = FactoryGirl.create(:bid, auction: auction, created_at: Time.current, amount: 1)
        first_bid = FactoryGirl.create(:bid, auction: auction, created_at: 1.hour.ago, amount: 1)

        expect(auction.lowest_bid).to eq (first_bid)
      end
    end
  end
end
