module ViewModel
  class AuctionShow < Struct.new(:current_user, :auction_record)
    include ActionView::Helpers::NumberHelper

    def auction
      @auction ||= ViewModel::Auction.new(current_user, auction_record)
    end

    delegate :title, :summary, :html_description, :status, :id, :bid_count, :current_bid_amount_as_currency,
      :issue_url, :user_bid_amount_as_currency, :show_bid_button?,
        to: :auction, prefix: true

    delegate :formatted_current_bid_amount, :current_bid_amount, :current_bid, :auction_type,
             to: :auction
    
    def auction_status_label
      if auction_won?
        "Winning bid (#{auction.current_bidder_name}):"
      else
        if auction.single_bid?
          "Your bid:"
        else
          "Current bid:"
        end
      end
    end

    def auction_status_partial
      if auction.single_bid? && !auction_won?
        'auctions/single_bid/auction_status'
      else
        'auctions/multi_bid/auction_status'
      end
    end

    def current_user_header_partial
      current_user_has_no_sam_verification? ? "/components/no_sam_verification_header" : win_header_partial
    end

    def win_header_partial
      return 'auctions/multi_bid/win_header'  if auction.multi_bid?
      return 'auctions/single_bid/win_header' if auction.single_bid?
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

    def auction_rules_link
      "<a href='#{auction_rules_href}'>Rules for #{auction.formatted_type} auctions</a>".html_safe
    end

    def auction_rules_href
      if auction.type == 'single_bid'
        return '/auctions/rules/single-bid'
      elsif auction.type == 'multi_bid'
        return '/auctions/rules/multi-bid'
      end
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
