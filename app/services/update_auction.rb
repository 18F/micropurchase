class UpdateAuction
  def initialize(auction:, params:, current_user:)
    @auction = auction
    @params = params
    @current_user = current_user
  end

  def perform
    auction.assign_attributes(attributes)

    if vendor_ineligible?
      auction.errors.add(:base, 'The vendor cannot be paid')
      false
    else
      create_purchase_request
      auction.save
    end
  end

  private

  attr_reader :auction, :params, :current_user

  def create_purchase_request
    if should_create_cap_proposal?
      CreateCapProposalJob.perform_later(auction.id)
    end
  end

  def should_create_cap_proposal?
    auction_accepted_and_cap_proposal_is_blank? &&
      auction.purchase_card == "default"
  end

  def vendor_ineligible?
    auction_accepted_and_cap_proposal_is_blank? &&
      !winning_bidder_is_eligible_to_be_paid?
  end

  def auction_accepted_and_cap_proposal_is_blank?
    attributes[:result] == 'accepted' && auction.cap_proposal_url.blank?
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

  def attributes
    @_attributes ||= AuctionParser.new(params, user).attributes
  end

  def user
    auction.user || current_user
  end
end
