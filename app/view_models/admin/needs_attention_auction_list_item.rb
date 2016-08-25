class Admin::NeedsAttentionAuctionListItem < Admin::BaseViewModel
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

  def accepted_at
    DcTimePresenter.convert_and_format(auction.accepted_at)
  end

  def payment_status
    if winning_bidder.payment_url.present?
      I18n.t('needs_attention.list_item.payment_status.pending')
    else
      I18n.t('needs_attention.list_item.payment_status.needs_credit_card_url')
    end
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
    auction.delivery_url || 'N/A'
  end

  def c2_proposal_url
    if auction.purchase_card == 'default'
      auction.c2_proposal_url
    else
      'N/A'
    end
  end

  def paid?
    auction.paid_at.present?
  end
end
