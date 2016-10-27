require 'rails_helper'

describe BiddingStatusPresenter::Over do
  describe '#tag_data_value_status' do
    it 'is closed' do
      presenter = BiddingStatusPresenter::Over.new(auction)
      expect(presenter.tag_data_value_status).to eq('Closed')
    end
  end

  describe '#tag_data_label_2' do
    it 'has a label about the winning bid amount' do
      presenter = BiddingStatusPresenter::Over.new(auction)
      expect(presenter.tag_data_label_2).to eq('Winning Bid')
    end
  end

  describe '#tag_data_value_2' do
    it 'returns winning bid amount' do
      presenter = BiddingStatusPresenter::Over.new(auction)
      expect(presenter.tag_data_value_2).to eq('$3,000.00')
    end
  end

  describe 'bid_label' do
    it 'should display the winning bid if the auction has bids' do
      bid = auction.bids.first
      bidder = bid.bidder
      presenter = BiddingStatusPresenter::Over.new(auction)
      user = create(:user)
      expect(presenter.bid_label(user)).to eq("Winning bid (#{bidder.name}): $3,000.00")
    end

    it 'should be an empty string if the auction has no bids' do
      auction = create(:auction, :closed)
      presenter = BiddingStatusPresenter::Over.new(auction)
      user = create(:user)
      expect(presenter.bid_label(user)).to eq('')
    end
  end

  describe '#relative_time' do
    it 'returns date that auction ended' do
      time = Time.local(2008, 9, 1)
      auction = create(:auction, :closed, ended_at: time)

      presenter = BiddingStatusPresenter::Over.new(auction)

      expect(presenter.relative_time).to eq 'Ended on 09/01/2008'
    end
  end

  def auction
    @_auction ||= create(
      :auction,
      :closed,
      start_price: 3500,
      bids: [create(:bid, amount: 3000)]
    )
  end
end
