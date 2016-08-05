class BidStatusPresenter::AvailableUserIsGuest < BidStatusPresenter::Base
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def body
    "This auction is accepting bids until #{end_date}. #{sign_in_link} or
    #{sign_up_link} with GitHub to bid."
  end
end
