module Rules
  # the basic auction type
  class Basic < Struct.new(:auction)
    def winning_bid
      auction.lowest_bid
    end

    def veiled_bids(user)
      auction.bids
    end

    # so tests will pass for moment; will remove later
    def single_bid?
      false
    end

    def multi_bid?
      true
    end

    def formatted_type
      'multi-bid'
    end
    
    def rules_type
      'basic'
    end
  end
end
