class PlaceBidValidator < ActiveModel::Validator
  def validate(bid)
    unless user_can_bid?(bid)
      add_error(bid, 'permissions')
    end

    if bid.amount <= 0
      add_error(bid, 'amount.below_zero')
    end

    if bid.amount > max_allowed_bid(bid)
      add_error(bid, 'amount.greater_than_max')
    end
  end

  private

  def add_error(bid, error)
    bid.errors.add :base, error_message(bid, error)
  end

  def error_message(bid, error)
    I18n.t "activerecord.errors.models.bid.#{error}",
           max_allowed_bid: max_allowed_bid(bid)
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
