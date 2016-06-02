class Rules::BaseRules
  attr_reader :auction
  attr_reader :eligibility

  def initialize(auction, eligibility)
    @auction = auction
    @eligibility = eligibility
  end

  def eligibility_label
    eligibility.label
  end

  def user_can_bid?(user)
    auction_available? && user.present? && user_is_eligible_to_bid?(user)
  end

  def auction_available?
    AuctionStatus.new(auction).available?
  end

  def user_is_eligible_to_bid?(user)
    eligibility.eligible?(user)
  end
end
