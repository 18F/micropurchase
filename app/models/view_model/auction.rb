module ViewModel
  class Auction < Struct.new(:current_user, :auction_record)
    include ActionView::Helpers::NumberHelper

    def auction
      @auction ||= Presenter::Auction.new(auction_record)
    end

    delegate :title, :summary, :html_description, :bid_count, :current_bid_amount_as_currency,
             :issue_url,
             :start_datetime, :end_datetime, :veiled_bids, :created_at, :current_bidder_name,
             :html_summary, :html_description, :formatted_type,
             :available?, :bids?, :bids, :human_start_time, :start_price,
             :over?,
             :multi_bid?, :single_bid?, :type,
             :id, :read_attribute_for_serialization, :to_param,
             to: :auction

    def user_can_bid?
      return false unless auction.available?
      return false if current_user.nil? || !current_user.sam_account?
      return false if auction.single_bid? && user_is_bidder?
      true
    end

    def show_bid_button?
      user_can_bid? || current_user.nil?
    end

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

    # can we get rid of Presenter::Auction view?
    def user_is_bidder?
      auction_user.has_bid?
    end

    def user_is_winning_bidder?
      return false unless auction.current_bid?
      current_user.id == auction.winning_bidder_id
    end
    
    def user_bids
      auction_user.bids
    end

    def lowest_user_bid
      auction_user.lowest_bid
    end

    def lowest_user_bid_amount
      auction_user.lowest_bid_amount
    end

    def user_bid_amount_as_currency
      number_to_currency(lowest_user_bid_amount)
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

    delegate :status, :label_class, :label, :tag_data_value_status, :tag_data_label_2, :tag_data_value_2,
             to: :status_presenter

    private

    def status_presenter_class
      status_name = if auction.expiring?
                      'Expiring'
                    elsif auction.over?
                      'Over'
                    elsif auction.future?
                      'Future'
                    else
                      'Open'
                    end
      "::Presenter::AuctionStatus::#{status_name}".constantize
    end

    def status_presenter
      @status_presenter ||= status_presenter_class.new(self)
    end

    def auction_user
      return Presenter::AuctionUser::Null.new if current_user.nil?
      @auction_user ||= Presenter::AuctionUser.new(bids, current_user)
    end
  end
end
