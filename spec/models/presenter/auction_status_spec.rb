require 'rails_helper'

RSpec.describe ViewModel::Auction do
  let(:user) { FactoryGirl.create(:user) }
  let(:presenter) { ViewModel::Auction.new(user, auction) }

  context "when the auction is expiring soon" do
    let(:auction) do
      a = Auction.new(start_datetime: Time.current - 3.days, end_datetime: Time.current + 3.hours, start_price: 3500, type: 1)
      a.bids.build(amount: 3000)
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

  context "when the auction is in progress" do
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

  context "when the auction is in the future" do
    let(:auction) do
      a = Auction.new(start_datetime: Time.now + 3.day, end_datetime: Time.now + 5.hours, start_price: 3500)
      a.bids.build(amount: 3000)
      a
    end

    it "has a twitter status data value with human readable time expression" do
      expect(presenter.tag_data_value_status).to eq("in 3 days")
    end

    it "has a twitter second label about the starting bid amount" do
      expect(presenter.tag_data_label_2).to eq("Starting bid")
    end

    it "has some weird value associated with the bidding label" do
      expect(presenter.tag_data_value_2).to eq("$3,500.00")
    end
  end

  context "when the auction is over" do
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
