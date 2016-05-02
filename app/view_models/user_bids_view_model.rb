class UserBidsViewModel
  attr_accessor :bids, :user

  def initialize(user, all_bids)
    @user = user
    @bids = all_bids.select { |b| b.bidder.id == user.id }
  end

  def bid?
    bids.any?
  end

  def lowest_bid
    @lowest ||= bids.sort_by(&:amount).first
  end

  def lowest_bid_amount
    lowest_bid.nil? ? nil : lowest_bid.amount
  end

  class Null
    def bid?
      false
    end

    def bids
      []
    end

    def lowest_bid
      nil
    end

    def lowest_bid_amount
      nil
    end
  end
end
