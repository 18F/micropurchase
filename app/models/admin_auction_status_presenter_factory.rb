class AdminAuctionStatusPresenterFactory
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def create
    if auction.purchase_card == 'default'
      default_purchase_card_presenter
    else
      other_purchase_card_presenter
    end.new(auction: auction)
  end

  private

  def default_purchase_card_presenter
    if auction.archived?
      AdminAuctionStatusPresenter::Archived
    elsif over_and_no_bids?
      AdminAuctionStatusPresenter::NoBids
    elsif auction.c2_status == 'not_requested'
      C2StatusPresenter::NotRequested
    elsif auction.c2_status == 'sent'
      C2StatusPresenter::Sent
    elsif auction.c2_status == 'pending_approval'
      C2StatusPresenter::PendingApproval
    elsif future? && auction.published?
      AdminAuctionStatusPresenter::Future
    elsif auction.unpublished?
      AdminAuctionStatusPresenter::ReadyToPublish
    elsif available?
      AdminAuctionStatusPresenter::Available
    elsif won? && auction.pending_delivery?
      AdminAuctionStatusPresenter::WorkNotStarted
    elsif overdue_delivery?
      AdminAuctionStatusPresenter::OverdueDelivery
    elsif auction.work_in_progress?
      AdminAuctionStatusPresenter::WorkInProgress
    elsif auction.missed_delivery?
      AdminAuctionStatusPresenter::MissedDelivery
    elsif auction.pending_acceptance?
      AdminAuctionStatusPresenter::PendingAcceptance
    elsif auction.accepted_pending_payment_url?
      AdminAuctionStatusPresenter::AcceptedPendingPaymentUrl
    elsif auction.accepted? && !(auction.c2_paid? || auction.payment_confirmed?)
      AdminAuctionStatusPresenter::DefaultPcard::Accepted
    elsif auction.rejected?
      AdminAuctionStatusPresenter::Rejected
    elsif auction.c2_paid?
      C2StatusPresenter::C2Paid
    else # auction.payment_confirmed?
      C2StatusPresenter::PaymentConfirmed
    end
  end

  def other_purchase_card_presenter
    if auction.archived?
      AdminAuctionStatusPresenter::Archived
    elsif future? && auction.published?
      AdminAuctionStatusPresenter::Future
    elsif auction.unpublished?
      AdminAuctionStatusPresenter::ReadyToPublish
    elsif available?
      AdminAuctionStatusPresenter::Available
    elsif overdue_delivery?
      AdminAuctionStatusPresenter::OverdueDelivery
    elsif auction.work_in_progress?
      AdminAuctionStatusPresenter::WorkInProgress
    elsif auction.missed_delivery?
      AdminAuctionStatusPresenter::MissedDelivery
    elsif auction.pending_acceptance?
      AdminAuctionStatusPresenter::PendingAcceptance
    elsif auction.accepted_pending_payment_url?
      AdminAuctionStatusPresenter::AcceptedPendingPaymentUrl
    elsif auction.accepted? && auction.paid_at.nil?
      AdminAuctionStatusPresenter::OtherPcard::Accepted
    elsif auction.accepted? && auction.paid_at.present?
      AdminAuctionStatusPresenter::OtherPcard::Paid
    else # auction.rejected?
      AdminAuctionStatusPresenter::Rejected
    end
  end

  def available?
    bidding_status.available?
  end

  def over_and_no_bids?
    over? && !bids?
  end

  def won?
    over? && bids?
  end

  def over?
    bidding_status.over?
  end

  def bids?
    auction.bids.any?
  end

  def future?
    bidding_status.future?
  end

  def overdue_delivery?
    won? &&
      (auction.pending_delivery? || auction.work_in_progress?) &&
      auction.delivery_due_at < Time.now
  end

  def bidding_status
    @_bidding_status ||= BiddingStatus.new(auction)
  end

  def delivery_status
    auction.delivery_status.camelize
  end

  def c2_status
    auction.c2_status.camelize
  end
end
