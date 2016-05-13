class Rules::BaseRules
  attr_reader :auction
  attr_reader :eligibility

  def initialize(auction, eligibility)
    @auction = auction
    @eligibility = eligibility
  end

  def partial_path(name, base_dir = 'auctions')
    "#{base_dir}/#{partial_prefix}/#{name}.html.erb"
  end

  def user_can_bid?(user)
    auction_available? && user.present? && @eligibility.eligible?(user)
  end

  def partial_prefix
    fail NotImplementedError
  end

  def auction_available?
    AuctionStatus.new(auction).available?
  end
end
