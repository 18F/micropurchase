module ViewModel
  class AuctionShow < Struct.new(:current_user, :auction_record)
    include ActionView::Helpers::NumberHelper

    def auction
      @auction ||= Policy::Auction.factory(auction_record, current_user)
    end

    def has_bids?
      auction.bids?
    end

    delegate :title, :summary, :html_description, :status, :id, :bid_count, :highlighted_bid,
      :issue_url, :user_bid_amount_as_currency, :rules_href, :display_type, :open_bid_status_label, :status_partial, :win_header_partial, :info_box_partial,
        to: :auction, prefix: true

    def auction_status_label
      if auction_won?
        "Winning bid (#{auction.winning_bidder_name}):"
      else
        auction_open_bid_status_label
      end
    end

    def formatted_highlighted_bid_amount
      if highlighted_bid_amount.nil?
        return 'n/a'
      else
        return number_to_currency(highlighted_bid_amount)
      end
    end

    def highlighted_bid_amount
      highlighted_bid.amount rescue nil
    end

    # This could be in the Presenter::Auction modelm but I don't want to make that change now
    # def current_bid
    #   return nil if current_user.nil?
    #   if auction.available? && auction.single_bid?
    #     auction.bids.detect {|bid| bid.bidder_id == current_user.id }
    #   else
    #     auction.current_bid
    #   end
    # end

    def current_user_header_partial
      current_user_has_no_sam_verification? ? "/components/no_sam_verification_header" : auction_win_header_partial
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
      "<a href='#{auction_rules_href}'>Rules for #{auction_display_type} auctions</a>".html_safe
    end

    private

    # FIXME
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
