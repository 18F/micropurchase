class BidStatusPresenter::Future::Guest < BidStatusPresenter::Base
  def body
    "This auction starts on #{start_date}. #{sign_in_link} or
    #{sign_up_link} with GitHub to bid."
  end
end
