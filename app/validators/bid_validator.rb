class BidValidator < ActiveModel::Validator
  def validate(bid)
    @bid = bid

    unless user_can_bid?
      add_error('You are not allowed to bid on this auction')
    end

    if amount <= 0
      add_error('Bid amount out of range')
    end

    if amount > max_allowed_bid
      add_error('Bids cannot be greater than the current max bid')
    end
  end

  private

  def add_error(message)
    @bid.errors.add :base, message
  end

  def auction
    @bid.auction
  end

  def amount
    @bid.amount
  end

  def user_can_bid?
    rules.user_can_bid?(@bid.bidder)
  end

  def max_allowed_bid
    rules.max_allowed_bid
  end

  def rules
    @_rules ||= RulesFactory.new(auction).create
  end
end
