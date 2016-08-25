class AdminAuctionStatusPresenter::Base
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def action_partial
    'components/null'
  end

  protected

  def winner
    WinningBid.new(auction).find.bidder
  end
end
