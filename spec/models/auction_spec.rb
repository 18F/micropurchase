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

  describe "#winning_bid" do
    context "auction is single bid and open" do
      it "returns nil" do
        auction = FactoryGirl.create(:auction, :single_bid, :running)

        expect(auction.winning_bid).to be_nil
      end
    end

    context "auction is single bid and closed" do
      it "returns lowest bid" do
        auction = FactoryGirl.create(:auction, :single_bid, :closed)
        low_bid = FactoryGirl.create(:bid, auction: auction, amount: 1)
        _high = FactoryGirl.create(:bid, auction: auction, amount: 10000)

        expect(auction.winning_bid).to eq low_bid
      end
    end

    context "auction is multi bid and open" do
      it "returns lowest bid" do
        auction = FactoryGirl.create(:auction, :available, :multi_bid)
        low_bid = FactoryGirl.create(:bid, auction: auction, amount: 1)
        _high = FactoryGirl.create(:bid, auction: auction, amount: 10000)

        expect(auction.winning_bid).to eq low_bid
      end
    end
  end
end
