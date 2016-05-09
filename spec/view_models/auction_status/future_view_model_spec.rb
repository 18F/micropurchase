require 'rails_helper'

describe AuctionStatus::FutureViewModel do
  context "when the auction is in the future" do
    let(:auction) do
      a = create(
        :auction,
        start_datetime: Time.now + 3.day,
        end_datetime: Time.now + 3.hours,
        start_price: 3500
      )
      create(:bid, auction: a, amount: 3000)
      a
    end

    it "has a twitter status data value with human readable time expression" do
      expect(auction.tag_data_value_status).to eq("in 3 days")
    end

    it "has a twitter second label about the starting bid amount" do
      expect(auction.tag_data_label_2).to eq("Starting bid")
    end

    it "has some weird value associated with the bidding label" do
      expect(auction.tag_data_value_2).to eq("$3,500.00")
    end
  end
end
