require 'rails_helper'

describe AuctionStatus::OpenViewModel do
  context "when the auction is open" do
    let(:auction) do
      a = create(
        :auction,
        start_datetime: Time.now - 3.days,
        end_datetime: Time.now + 2.days,
        start_price: 3500
      )
      create(:bid, auction: a, amount: 3000)
      a
    end

    it "has a twitter status data value with human readable time expression" do
      expect(auction.tag_data_value_status).to eq("2 days left")
    end

    it "has a twitter second label that indicates bidding is open" do
      expect(auction.tag_data_label_2).to eq("Bidding")
    end

    it "has some weird value associated with the bidding label" do
      expect(auction.tag_data_value_2(nil)).to eq("$3,000.00 - 1 bids")
    end
  end
end
