module Presenter
  class Auction < SimpleDelegator
    def current_bid
      @current_bid ||= bids.sort_by{|bid| [bid.amount, bid.created_at, bid.id]}.first
    end

    def current_bid_amount
      current_bid && current_bid.amount
    end

    def bids?
      bids.size > 0
    end

    def bids
      __getobj__.bids.to_a
    end

    def available?
      !!(
        (start_datetime && (start_datetime <= Time.now)) &&
          (end_datetime && (end_datetime >= Time.now))
      )
    end
  end
end
