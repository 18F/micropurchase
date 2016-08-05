class BidStatusPresenter::AvailableSealedUserIsBidder < BidStatusPresenter::Base
  attr_reader :bid

  def initialize(bid:)
    @bid = bid
  end

  def header
    ''
  end

  def body
    "You bid #{Currency.new(bid.amount)} on #{DcTimePresenter.convert_and_format(bid.created_at)}."
  end
end
