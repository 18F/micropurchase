class AcceptAuction
  attr_reader :auction, :payment_url

  def initialize(auction:, payment_url: '')
    @auction = auction
    @payment_url = payment_url
  end

  def perform
    if vendor_ineligible?
      auction.errors.add(:base, I18n.t('errors.update_auction.vendor_ineligible'))
      false
    else
      accept_auction
    end
  end

  private

  def accept_auction
    auction.accepted_at = Time.current

    if payment_url.blank?
      auction.delivery_status = :accepted_pending_payment_url
      send_winning_bidder_missing_payment_method_email
    else
      auction.delivery_status = :accepted
      send_auction_accepted_emails
      update_purchase_request
    end
  end

  def vendor_ineligible?
    !winning_bidder_is_eligible_to_be_paid?
  end

  def winning_bidder_is_eligible_to_be_paid?
    if auction_is_small_business?
      reckoner = SamAccountReckoner.new(winning_bidder)
      reckoner.set!
      winning_bidder.reload
      user_is_eligible_to_bid?
    else
      true
    end
  end

  def user_is_eligible_to_bid?
    auction_rules.user_is_eligible_to_bid?(winning_bidder)
  end

  def auction_rules
    RulesFactory.new(auction).create
  end

  def auction_is_small_business?
    AuctionThreshold.new(auction).small_business?
  end

  def winning_bidder
    WinningBid.new(auction).find.bidder
  end

  def send_winning_bidder_missing_payment_method_email
    WinningBidderMailer
      .auction_accepted_missing_payment_method(auction: auction)
      .deliver_later
  end

  def send_auction_accepted_emails
    WinningBidderMailer.auction_accepted(auction: auction).deliver_later
    if customer && customer.email.present?
      AuctionMailer
        .auction_accepted_customer_notification(auction: auction)
        .deliver_later
    end
  end

  def update_purchase_request
    if auction.purchase_card == "default"
      UpdateC2ProposalJob.perform_later(auction.id, 'C2UpdateAttributes')
    end
  end

  def customer
    auction.customer
  end
end
