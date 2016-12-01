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

  def c2_proposal_url
    auction.c2_proposal_url
  end

  def payment_url
    winning_bidder.payment_url
  end

  def winning_amount
    Currency.new(winning_bid.amount).to_s
  end

  def ended_at
    DcTimePresenter.convert_and_format(auction.ended_at)
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

  def winning_bid
    @_winning ||= WinningBid.new(auction).find
  end

  def winning_bidder
    winning_bid.bidder || NullBidder.new
  end
end
