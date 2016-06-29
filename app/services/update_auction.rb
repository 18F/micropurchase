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
      perform_approved_auction_tasks
      auction.save
    end
  end

  private

  attr_reader :auction, :params, :current_user

  def perform_approved_auction_tasks
    if auction_accepted? && auction.accepted_at.nil?
      auction.accepted_at = Time.current
    end

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
    auction_accepted? && auction.cap_proposal_url.blank?
  end

  def auction_accepted?
    attributes[:result] == 'accepted'
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
