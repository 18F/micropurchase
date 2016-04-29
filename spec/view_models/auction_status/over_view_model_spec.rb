require 'rails_helper'

describe AuctionStatus::OverViewModel do
  context "when the auction is over" do
    let(:presenter) { AuctionViewModel.new(create(:user), auction) }
    let(:auction) do
      a = Auction.new(start_datetime: Time.now - 5.day, end_datetime: Time.now - 5.hours, start_price: 3500)
      a.bids.build(amount: 3000)
      a
    end

    it "has a twitter status data value with human readable time expression" do
      expect(presenter.tag_data_value_status).to eq("Closed")
    end

    it "has a twitter second label about the winning bid amount" do
      expect(presenter.tag_data_label_2).to eq("Winning Bid")
    end

    it "has some weird value associated with the bidding label" do
      expect(presenter.tag_data_value_2).to eq("$3,000.00")
    end
  end
end
