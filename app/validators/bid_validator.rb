class BidValidator < ActiveModel::Validator
  def validate(bid)
    unless user_can_bid?(bid)
      add_error(bid, 'You are not allowed to bid on this auction')
    end

    if bid.amount <= 0
      add_error(bid, 'Bid amount out of range')
    end

    if bid.amount > max_allowed_bid(bid)
      add_error(bid, 'Bids cannot be greater than the current max bid')
    end
  end

  private

  def add_error(bid, message)
    bid.errors.add :base, message
  end

  def user_can_bid?(bid)
    rules(bid).user_can_bid?(bid.bidder)
  end

  def max_allowed_bid(bid)
    rules(bid).max_allowed_bid
  end

  def rules(bid)
    RulesFactory.new(bid.auction).create
  end
end
