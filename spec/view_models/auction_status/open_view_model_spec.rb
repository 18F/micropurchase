require 'rails_helper'

describe AuctionStatus::OpenViewModel do
  context "when the auction is open" do
    let(:presenter) { AuctionViewModel.new(create(:user), auction) }
    let(:auction) do
      a = Auction.new(start_datetime: Time.now - 3.day, end_datetime: Time.now + 2.days, start_price: 3500, type: 1)
      a.bids.build(amount: 3000)
      a
    end

    it "has a twitter status data value with human readable time expression" do
      expect(presenter.tag_data_value_status).to eq("2 days left")
    end

    it "has a twitter second label that indicates bidding is open" do
      expect(presenter.tag_data_label_2).to eq("Bidding")
    end

    it "has some weird value associated with the bidding label" do
      expect(presenter.tag_data_value_2).to eq("$3,000.00 - 1 bids")
    end
  end
end
