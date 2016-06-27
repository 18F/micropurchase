class HighlightedBid
  attr_reader :auction, :user

  def initialize(auction:, user:)
    @auction = auction
    @user = user
  end

  def find
    auction_rules.highlighted_bid(user)
  end

  private

  def auction_rules
    RulesFactory.new(auction).create
  end
end
