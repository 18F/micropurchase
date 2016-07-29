class Admin::ClosedAuctionsListItemViewModel
  attr_reader :auction

  def initialize(auction)
    @auction = auction
  end

  def title
    auction.title
  end

  def id
    auction.id
  end

  def delivery_url
    auction.delivery_url
  end

  def accepted_at
    DcTimePresenter.convert_and_format(auction.accepted_at)
  end

  def rejected_at
    DcTimePresenter.convert_and_format(auction.rejected_at)
  end

  def winning_vendor_github_login
    winning_bidder.github_login
  end

  private

  def winning_bidder
    WinningBid.new(auction).find.bidder || NullBidder.new
  end
end
