class Admin::ActionItemListItem < Admin::BaseViewModel
  attr_reader :auction

  def initialize(auction)
    @auction = auction
  end

  def title
    auction.title
  end

  def winning_bid
    @_winner ||= WinningBid.new(auction).find
  end

  def winning_bidder
    winning_bid.decorated_bidder
  end

  def id
    auction.id
  end

  def delivery_due_at_expires_in
    HumanTime.new(time: auction.delivery_due_at).relative_time
  end

  def delivery_due_at
    DcTimePresenter.convert_and_format(auction.delivery_due_at)
  end

  def rejected_at
    DcTimePresenter.convert_and_format(auction.rejected_at)
  end

  def delivery_url
    auction.delivery_url
  end

  def result
    auction.result
  end

  def c2_proposal_url
    auction.c2_proposal_url
  end

  def paid?
    auction.paid_at.present?
  end
end
