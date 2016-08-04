class BidStatusPresenter::FutureUserIsVendor < BidStatusPresenter::Base
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def body
    "This auction starts on #{start_date}."
  end

  private

  def start_date
    DcTimePresenter.convert_and_format(auction.started_at)
  end
end
