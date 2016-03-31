module ViewModel
  class Auction < Struct.new(:current_user, :auction_record)
    include ActionView::Helpers::NumberHelper

    def auction
      @auction ||= Presenter::Auction.new(auction_record)
    end

    delegate :title, :summary, :html_description, :status, :id, :bid_count, :current_bid_amount_as_currency,
             :issue_url, :user_bid_amount_as_currency,
             :start_datetime, :end_datetime, :veiled_bids, :created_at, :current_bidder_name,
             :label_class, :label, :html_summary, :html_description, :formatted_type,
             :available?, :bids?, :bids, :human_start_time, :show_bid_button?, :start_price,
             :tag_data_value_status, :over?, :tag_data_label_2, :tag_data_value_2,
             :multi_bid?, :single_bid?, :type, :user_is_bidder?, :user_is_winning_bidder?,
             :id, :read_attribute_for_serialization, :to_param,
             to: :auction

    def formatted_current_bid_amount
      if current_bid_amount.nil?
        return 'n/a'
      else
        return number_to_currency(current_bid_amount)
      end
    end

    def current_bid_amount
      current_bid.amount rescue nil
    end

    # This could be in the Presenter::Auction modelm but I don't want to make that change now
    def current_bid
      return nil if current_user.nil?
      if auction.available? && auction.single_bid?
        auction.bids.detect {|bid| bid.bidder_id == current_user.id }
      else
        auction.current_bid
      end
    end

    def auction_type
      auction.formatted_type
    end

    def index_bid_summary_partial
      if auction.single_bid?
        'auctions/single_bid/index_bid_summary'
      elsif auction.multi_bid?
        'auctions/multi_bid/index_bid_summary'
      end
    end

    def current_bid_info_partial
      if auction.single_bid?
        'bids/single_bid/current_bid_info'
      elsif auction.multi_bid?
        'bids/multi_bid/current_bid_info'
      end
    end

  end
end
