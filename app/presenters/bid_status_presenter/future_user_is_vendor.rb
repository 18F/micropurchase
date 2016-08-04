class BidStatusPresenter::FutureUserIsVendor < BidStatusPresenter::Base
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def body
    "This auction starts on #{start_date}."
  end
end
