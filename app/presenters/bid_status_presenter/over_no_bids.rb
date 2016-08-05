class BidStatusPresenter::OverNoBids < BidStatusPresenter::Base
  def header
    'Auction Now Closed'
  end

  def body
    'This auction ended with no bids.'
  end
end
