class BidStatusPresenter::AvailableReverseUserIsOutbid < BidStatusPresenter::Base
  def header
    'Place bid'
  end

  def body
    "You've been outbid! The maximum you can bid is
    #{max_allowed_bid_as_currency}."
  end

  def action_partial
    'auctions/bid_form'
  end

  private

  def max_allowed_bid_as_currency
    Currency.new(rules.max_allowed_bid)
  end

  def rules
    @_rules ||= RulesFactory.new(auction).create
  end
end
