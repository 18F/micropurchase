class AdminAuctionStatusPresenterFactory
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def create
    presenter_class.new(auction: auction)
  end

  private

  def presenter_class
    if auction.purchase_card == 'default'
      default_purchase_card_presenter_class
    else
      other_purchase_card_presenter_class
    end
  end

  def default_purchase_card_presenter_class
    ordered_default_pcard_presenter_classes.detect do |presenter_class|
      presenter_class.relevant?(BidStatusInformation.new(auction))
    end || C2StatusPresenter::PaymentConfirmed
  end

  def other_purchase_card_presenter_class
    ordered_other_pcard_classes.detect do |presenter_class|
      presenter_class.relevant?(BidStatusInformation.new(auction))
    end || AdminAuctionStatusPresenter::Rejected
  end

  def ordered_other_pcard_classes
    [
      AdminAuctionStatusPresenter::Archived,
      AdminAuctionStatusPresenter::NoBids,
      AdminAuctionStatusPresenter::Future,
      AdminAuctionStatusPresenter::ReadyToPublish,
      AdminAuctionStatusPresenter::Available,
      AdminAuctionStatusPresenter::OverdueDelivery,
      AdminAuctionStatusPresenter::WorkInProgress,
      AdminAuctionStatusPresenter::MissedDelivery,
      AdminAuctionStatusPresenter::PendingAcceptance,
      AdminAuctionStatusPresenter::AcceptedPendingPaymentUrl,
      AdminAuctionStatusPresenter::OtherPcard::Accepted,
      AdminAuctionStatusPresenter::OtherPcard::Paid
    ]
  end

  def ordered_default_pcard_presenter_classes
    [
      AdminAuctionStatusPresenter::Archived,
      AdminAuctionStatusPresenter::NoBids,
      C2StatusPresenter::NotRequested,
      C2StatusPresenter::Sent,
      C2StatusPresenter::PendingApproval,
      AdminAuctionStatusPresenter::Future,
      AdminAuctionStatusPresenter::ReadyToPublish,
      AdminAuctionStatusPresenter::Available,
      AdminAuctionStatusPresenter::WorkNotStarted,
      AdminAuctionStatusPresenter::OverdueDelivery,
      AdminAuctionStatusPresenter::WorkInProgress,
      AdminAuctionStatusPresenter::MissedDelivery,
      AdminAuctionStatusPresenter::PendingAcceptance,
      AdminAuctionStatusPresenter::AcceptedPendingPaymentUrl,
      AdminAuctionStatusPresenter::DefaultPcard::Accepted,
      AdminAuctionStatusPresenter::Rejected,
      C2StatusPresenter::C2Paid
    ]
  end

  class BidStatusInformation
    attr_reader :auction, :bid_status

    def initialize(auction)
      @auction = auction
      @bid_status = BiddingStatus.new(auction)
    end

    delegate  :archived?,
              :published?,
              :unpublished?,
              :pending_delivery?,
              :work_in_progress?,
              :pending_acceptance?,
              :accepted_pending_payment_url?,
              :missed_delivery?,
              :accepted?,
              :c2_paid?,
              :payment_confirmed?,
              :rejected?,
              to: :auction

    def available?
      bid_status.available?
    end

    def over_and_no_bids?
      over? && !bids?
    end

    def c2_not_requested?
      auction.c2_status == 'not_requested'
    end

    def c2_sent?
      auction.c2_status == 'sent'
    end

    def c2_pending?
      auction.c2_status == 'pending_approval'
    end

    def won?
      over? && bids?
    end

    def over?
      bid_status.over?
    end

    def bids?
      auction.bids.any?
    end

    def future?
      bid_status.future?
    end

    def pending_delivery?
      auction.pending_delivery?
    end

    def overdue_delivery?
      won? &&
        (auction.pending_delivery? || auction.work_in_progress?) &&
        auction.delivery_due_at < Time.now
    end

    def delivery_status
      auction.delivery_status.camelize
    end

    def c2_status
      auction.c2_status.camelize
    end

    def paid_at_info?
      !auction.paid_at.nil?
    end
  end
end
