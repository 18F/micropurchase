module Presenter
  class AdminAuction < SimpleDelegator
    def bids?
      bid_count > 0
    end

    def bids
      model.bids.to_a
           .map {|bid| Presenter::Bid.new(bid) }
           .sort_by(&:created_at)
           .reverse
    end

    def bid_count
      bids.size
    end

    private
    
    def model
      __getobj__
    end
  end
end
