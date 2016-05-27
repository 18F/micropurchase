require 'rails_helper'

describe AuctionStatus::ExpiringViewModel do
  context "when the auction is expiring soon" do
    let(:presenter) { AuctionStatus::ExpiringViewModel.new(auction) }
    let(:auction) do
      a = create(
        :auction,
        started_at: Time.now - 3.days,
        ended_at: Time.now + 3.hours,
        start_price: 3500
      )
      create(:bid, amount: 3000, auction: a)
      a
    end

    it "has a twitter status data value with human readable time expression" do
      expect(presenter.tag_data_value_status).to eq("about 3 hours left")
    end

    it "has a twitter second label that indicates bidding is open" do
      expect(presenter.tag_data_label_2).to eq("Bidding")
    end

    it "has some weird value associated with the bidding label" do
      expect(presenter.tag_data_value_2).to eq("$3,000.00 - 1 bids")
    end
  end
end
