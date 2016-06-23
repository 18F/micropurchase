class Admin::BidListItem < Admin::BaseViewModel
  attr_reader :bid

  def initialize(bid)
    @bid = bid
  end

  def bidder_name
    bidder.name
  end

  def bidder_duns_number
    bidder.duns_number
  end

  def amount
    Currency.new(bid.amount).to_s
  end

  def time
    DcTimePresenter.convert_and_format(bid.created_at)
  end

  private

  def bidder
    @_bidder ||= bid.bidder
  end
end
