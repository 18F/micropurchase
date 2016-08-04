class BidStatusPresenter::AvailableUserIsAdmin < BidStatusPresenter::Base
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def body
    "This auction is accepting bids until #{end_date}."
  end
end
