# This class encapsulates representations of the Auction used in
# controller responses (views and API json) as well as access methods
# tied to the current user.
module ViewModel
  class Auction < Struct.new(:current_user, :auction_record)
    include ActionView::Helpers::NumberHelper

    def auction
      @auction ||= Presenter::Auction.new(auction_record)
    end

    delegate(
      :auction_rules_href,
      :available?,
      :bid_count,
      :bids,
      :bids?,
      :created_at,
      :end_datetime,
      :expiring?,
      :formatted_type,
      :future?,
      :highlighted_bid_label,
      :html_description,
      :html_description,
      :html_summary,
      :human_start_time,
      :id,
      :issue_url,
      :over?,
      :partial_path,
      :read_attribute_for_serialization,
      :show_bids?,
      :start_datetime,
      :start_price,
      :summary,
      :title,
      :to_param,
      :type,
      :updated_at,
      :veiled_bids,
      to: :auction
    )

    def user_can_bid?
      auction.user_can_bid?(current_user)
    end

    def highlighted_bid
      auction.highlighted_bid(current_user)
    end
    
    def show_bid_button?
      user_can_bid? || current_user.nil?
    end

    delegate :amount, to: :highlighted_bid, prefix: true

    def highlighted_bid_amount_as_currency
      number_to_currency(highlighted_bid_amount)
    end

    def highlighted_bidder_name
      highlighted_bid.bidder_name
    end

    def user_is_bidder?
      user_bids_obj.has_bid?
    end

    def user_is_winning_bidder?
      # fixme: who is calling this?
      return false unless auction.bids?
      current_user.id == auction.winning_bidder_id
    end

    def user_bids
      user_bids_obj.bids
    end

    def lowest_user_bid
      user_bids_obj.lowest_bid
    end

    def lowest_user_bid_amount
      user_bids_obj.lowest_bid_amount
    end

    def user_bid_amount_as_currency
      number_to_currency(lowest_user_bid_amount)
    end

    def auction_type
      auction.formatted_type
    end

    def index_bid_summary_partial
      auction.partial_path('index_bid_summary')
    end

    def highlighted_bid_info_partial
      auction.partial_path('highlighted_bid_info', 'bids')
    end

    delegate(
      :label,
      :label_class,
      :status_text,
      :tag_data_label_2,
      :tag_data_value_status,
      :tag_data_value_2,
      to: :status_presenter
    )
    
    private

    def status_presenter_class
      status_name = if expiring?
                      'Expiring'
                    elsif over?
                      'Over'
                    elsif future?
                      'Future'
                    else
                      'Open'
                    end
      "::ViewModel::AuctionStatus::#{status_name}".constantize
    end

    def status_presenter
      @status_presenter ||= status_presenter_class.new(self)
    end

    def user_bids_obj
      return ViewModel::UserBids::Null.new if current_user.nil?
      @user_bids_obj ||= ViewModel::UserBids.new(current_user, auction.bids)
    end
  end
end
