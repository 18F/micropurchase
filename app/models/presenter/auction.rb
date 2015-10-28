module Presenter
  class Auction < SimpleDelegator
    def current_bid?
      !!current_bid_record
    end

    def current_bid
      return Presenter::Bid::Null.new unless current_bid_record
      Presenter::Bid.new(current_bid_record)
    end

    def current_bid_amount
      current_bid.amount
    end

    def current_bidder_name
      current_bid.bidder_name
    end

    def current_bidder_duns_number
      current_bid.bidder_duns_number
    end

    def current_bid_time
      current_bid.time
    end

    def bids?
      bids.size > 0
    end

    def bids
      model.bids.to_a.map{|bid| Presenter::Bid.new(bid) }
    end

    def starts_at
      Presenter::DcTime.convert_and_format(model.start_datetime)
    end

    def ends_at
      Presenter::DcTime.convert_and_format(model.end_datetime)
    end

    def available?
      !!(
        (model.start_datetime && (model.start_datetime <= Time.now)) &&
          (model.end_datetime && (model.end_datetime >= Time.now))
      )
    end

    private

    def current_bid_record
      @current_bid_record ||= bids.sort_by{|bid| [bid.amount, bid.created_at, bid.id]}.first
    end

    def model
      __getobj__
    end
  end
end
