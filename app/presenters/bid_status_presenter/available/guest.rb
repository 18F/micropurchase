class BidStatusPresenter::Available::Guest < BidStatusPresenter::Base
  def body
    "This auction is accepting bids until #{end_date}. #{sign_in_link} or
    #{sign_up_link} with GitHub to bid."
  end
end
