require 'rails_helper'

describe BiddingStatusPresenter::Available do
  describe '#tag_data_value_status' do
    it "has a twitter status data value with human readable time expression" do
      presenter = BiddingStatusPresenter::Available.new(auction)
      expect(presenter.tag_data_value_status).to eq("2 days left")
    end
  end

  describe '#tag_data_label_2' do
    it "has a twitter second label that indicates bidding is open" do
      presenter = BiddingStatusPresenter::Available.new(auction)
      expect(presenter.tag_data_label_2).to eq("Bidding")
    end
  end

  describe '#tag_data_value_2' do
    it "has some weird value associated with the bidding label" do
      presenter = BiddingStatusPresenter::Available.new(auction)
      expect(presenter.tag_data_value_2).to eq("$3,000.00 - 1 bids")
    end
  end

  describe '#relative_time' do
    it 'returns time remaining' do
      presenter = BiddingStatusPresenter::Available.new(auction)
      expect(presenter.relative_time).to eq("Ending in 2 days")
    end
  end

  def auction
    @_auction ||= create(
      :auction,
      :available,
      start_price: 3500,
      bids: [create(:bid, amount: 3000)]
    )
  end
end
