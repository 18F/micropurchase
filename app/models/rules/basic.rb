module Rules
  # the basic auction type
  class Basic < Struct.new(:auction)
    def winning_bid
      auction.lowest_bid
    end

    def veiled_bids(user)
      auction.bids
    end

    def user_can_bid?(user)
      return false unless auction.available?
      return false if user.nil? || !user.sam_account?
      true
    end

    def max_allowed_bid
      if auction.lowest_bid.is_a?(Presenter::Bid::Null)
        return auction.start_price - PlaceBid::BID_INCREMENT
      else
        return auction.lowest_amount - PlaceBid::BID_INCREMENT
      end
    end

    # so tests will pass for moment; will remove later
    def single_bid?
      false
    end

    def multi_bid?
      true
    end

    def partial_path(name, base_dir='auctions')
      if partial_prefix.blank?
        "#{base_dir}/#{name}.html.erb"
      else
        "#{base_dir}/#{partial_prefix}/#{name}.html.erb"
      end
    end

    def partial_prefix
      'multi_bid'
    end

    def formatted_type
      'multi-bid'
    end

    def rules_type
      'basic'
    end
  end
end
