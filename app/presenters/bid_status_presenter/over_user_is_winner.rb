class BidStatusPresenter::OverUserIsWinner < BidStatusPresenter::Base
  def header
    'You are the winner'
  end

  def body
    'Congratulations! We will contact you with further instructions.'
  end
end
