class BidStatusPresenter::FutureUserIsGuest < BidStatusPresenter::Base
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def body
    "This auction starts on #{start_date}. #{sign_in_link} or
    #{sign_up_link} with GitHub to bid."
  end
end
