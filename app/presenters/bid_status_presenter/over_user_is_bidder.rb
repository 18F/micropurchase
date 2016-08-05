class BidStatusPresenter::OverUserIsBidder < BidStatusPresenter::Base
  def header
    'You are not the winner'
  end

  def body
    'Someone else placed a lower bid than you.'
  end
end
