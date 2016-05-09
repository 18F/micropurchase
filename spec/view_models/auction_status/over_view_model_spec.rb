require 'rails_helper'

describe AuctionStatus::OverViewModel do
  context "when the auction is over" do
    let(:auction) do
      a = create(
        :auction,
        start_datetime: Time.now - 5.days,
        end_datetime: Time.now - 5.hours,
        start_price: 3500
      )
      create(:bid, auction: a, amount: 3000)
      a
    end

    it "has a twitter status data value with human readable time expression" do
      expect(auction.tag_data_value_status).to eq("Closed")
    end

    it "has a twitter second label about the winning bid amount" do
      expect(auction.tag_data_label_2).to eq("Winning Bid")
    end

    it "has some weird value associated with the bidding label" do
      expect(auction.tag_data_value_2).to eq("$3,000.00")
    end
  end
end
