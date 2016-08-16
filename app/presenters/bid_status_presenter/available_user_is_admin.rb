class BidStatusPresenter::AvailableUserIsAdmin < BidStatusPresenter::Base
  def body
    "This auction is accepting bids until #{end_date}."
  end
end
