class BidStatusPresenter::AvailableUserIsAdmin < BidStatusPresenter::Base
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def body
    "This auction is accepting bids until #{end_date}."
  end

  private

  def end_date
    DcTimePresenter.convert_and_format(auction.ended_at)
  end
end
