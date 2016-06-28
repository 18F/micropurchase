class AuctionAccepted
  def initialize(auction)
    @auction = auction
  end

  def perform
    if vendor_ineligible?
      auction.errors.add(:base, 'The vendor is ineligible from being paid.')
    else
      request_credit_card_form_url
      create_purchase_request
    end
  end

  private

  attr_reader :auction

  def request_credit_card_form_url

    if should_request_credit_card_form_url?
      RequestCreditCardFormUrlEmailSender.new(auction).perform
      auction.errors.add(:base, 'The vendor is missing their credit card. An email was sent to them requesting a credit card form URL.')
    end
  end

  def should_request_credit_card_form_url?
    winning_bidder_lacks_credit_card_form_url?
  end

  def create_purchase_request
    if should_create_cap_proposal?
      CreateCapProposalJob.perform_later(auction.id)
    end
  end

  def should_create_cap_proposal?
    cap_proposal_is_blank? &&
      auction.purchase_card == "default" &&
      winning_bidder_has_credit_card_form_url?
  end

  def vendor_ineligible?

    !winning_bidder_is_eligible_to_be_paid?
  end

  def cap_proposal_is_blank?
    auction.cap_proposal_url.blank?
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

  def winning_bidder_has_credit_card_form_url?
    !winning_bidder_lacks_credit_card_form_url?
  end

  def winning_bidder_lacks_credit_card_form_url?
    winning_bidder.credit_card_form_url.nil? ||
      winning_bidder.credit_card_form_url.empty?
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
end
