require 'rails_helper'

describe BiddingStatusPresenter::Future do
  describe '#tag_data_value_status' do
    it "returns human readable time" do
      presenter = BiddingStatusPresenter::Future.new(auction)
      expect(presenter.tag_data_value_status).to eq("in 3 days")
    end
  end

  describe '#tag_data_label_2' do
    it "returns starting bid" do
      presenter = BiddingStatusPresenter::Future.new(auction)
      expect(presenter.tag_data_label_2).to eq("Starting bid")
    end
  end

  describe '#tag_data_value_2' do
    it "returns start price" do
      presenter = BiddingStatusPresenter::Future.new(auction)
      expect(presenter.tag_data_value_2).to eq("$3,500.00")
    end
  end

  describe '#relative_time' do
    it 'returns time until auction starts' do
      auction = create(:auction, :future)
      presenter = BiddingStatusPresenter::Future.new(auction)

      expect(presenter.relative_time).to eq("Opens #{DcTimePresenter.new(auction.started_at).relative_time}")
    end
  end

  describe '#bid_label' do
    it 'should display the starting price of the auction' do
      presenter = BiddingStatusPresenter::Future.new(auction)
      user = create(:user)
      expect(presenter.bid_label(user)).to eq("Starting price: $3,500.00")
    end
  end

  def auction
    @_auction ||= create(
      :auction,
      :future,
      started_at: Time.now + 3.days,
      start_price: 3500,
      bids: [create(:bid, amount: 3000)]
    )
  end
end
