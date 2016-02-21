module ViewModel
  class AuctionShow < Struct.new(:current_user, :auction_record)
    def auction
      @auction ||= Presenter::Auction.new(auction_record)
    end

    delegate :title, :summary, :html_description, :status, :id, :bid_count, :current_bid_amount_as_currency,
             :issue_url,
             to: :auction,
             prefix: true

    def auction_status_label
      auction_won? ? "Winning bid (#{auction.current_bidder_name}):" : "Current bid:"
    end

    def current_user_header_partial
      current_user_has_no_sam_verification? ? "/components/no_sam_verification_header" : "auctions/win_header"
    end

    def auction_link_text
      "#{auction.bid_count} #{bid_to_plural}"
    end

    def auction_deadline_label
      auction.over? ? "Auction ended at:" : "Bid deadline:"
    end

    def auction_formatted_end_time
      return "" unless auction.end_datetime
      auction.end_datetime.strftime("%m/%d/%Y at %I:%M %p %Z")
    end

    def auction_start_label
      auction.over? ? "Auction started at:" : "Bid start time:"
    end

    def auction_formatted_start_time
      return "" unless auction.start_datetime
      auction.start_datetime.strftime("%m/%d/%Y at %I:%M %p %Z")
    end

    private

    def bid_to_plural
      auction.bids? ? "bids" : "bid"
    end

    def auction_won?
      auction.over? && auction.bids?
    end

    def current_user_has_no_sam_verification?
      current_user && !current_user.sam_account?
    end

  end
end