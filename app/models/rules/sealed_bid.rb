module Rules
  class SealedBid < Rules::Basic
    def winning_bid
      return Presenter::Bid::Null.new if auction.available?
      auction.lowest_bid
    end

    def veiled_bids(user)
      if auction.available?
        return [] if user.nil?
        auction.bids.select {|bid| bid.bidder_id == user.id}
      else
        auction.bids
      end
    end

    def user_can_bid?(user)
      super && !auction.bids.any? {|b| b.bidder_id == user.id }
    end

    def max_allowed_bid
      auction.start_price - PlaceBid::BID_INCREMENT
    end
    
    # so tests will pass for moment; will remove later
    def single_bid?
      true
    end

    def multi_bid?
      false
    end

    def formatted_type
      'single-bid'
    end
    
    def rules_type
      'sealed-bid'
    end
  end
end
