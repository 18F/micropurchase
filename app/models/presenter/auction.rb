require 'action_view'

module Presenter
  class Auction
    include ActiveModel::SerializerSupport
    include ActionView::Helpers::DateHelper
    include ActionView::Helpers::NumberHelper

    def initialize(auction)
      @auction = auction
    end
    
    def user_can_bid?(user)
      return false unless available?
      return false if user.nil? || !user.sam_account?
      return false if single_bid? && user_is_bidder?(user)
      true
    end

    def show_bid_button?(user)
      user_can_bid?(user) || user.nil?
    end

    def current_bid?
      current_bid_record != nil
    end

    def current_bid
      return Presenter::Bid::Null.new unless current_bid_record
      Presenter::Bid.new(current_bid_record)
    end

    def current_max_bid
      if current_bid.is_a?(Presenter::Bid::Null)
        return start_price - PlaceBid::BID_INCREMENT
      else
        return current_bid.amount - PlaceBid::BID_INCREMENT
      end
    end

    delegate :title, :created_at, :start_datetime, :end_datetime,
             :github_repo, :issue_url, :summary, :description,
             :delivery_deadline, :start_price, :published, :to_param,
             :model_name, :to_key, :to_model, :type, :id,
             :read_attribute_for_serialization,
             to: :model

    delegate :amount, :time,
             to: :current_bid, prefix: :current_bid

    delegate :bidder_name, :bidder_duns_number,
             to: :current_bid, prefix: :current

    def current_bid_amount_as_currency
      number_to_currency(current_bid_amount)
    end

    def user_bid_amount_as_currency(user)
      number_to_currency(lowest_user_bid_amount(user))
    end

    def bids?
      bid_count > 0
    end

    def bids
      model.bids.to_a
           .map {|bid| Presenter::Bid.new(bid) }
           .sort_by(&:created_at)
           .reverse
    end

    def veiled_bids(user)
      # For single bid auctions, we reveal no bids if the auction is running
      # For multi bid auctions, we let the bids go through, but depend on
      # Presenter::Bid to veil certain attributes.

      # redact all bids if auction is still running and type is single bid
      if available? && single_bid?
        return [] if user.nil?
        return bids.select {|bid| bid.bidder_id == user.id}
      end

      # otherwise, return all the bids
      return bids
    end

    def bid_count
      bids.size
    end

    def starts_at
      Presenter::DcTime.convert_and_format(model.start_datetime)
    end

    def ends_at
      Presenter::DcTime.convert_and_format(model.end_datetime)
    end

    def formatted_type
      return 'multi-bid'  if model.type == 'multi_bid'
      return 'single-bid' if model.type == 'single_bid'
    end

    def type
      model.type
    end

    def starts_in
      time_in_human(model.start_datetime)
    end

    def ends_in
      time_in_human(model.end_datetime)
    end

    def delivery_deadline_expires_in
      time_in_human(model.delivery_deadline)
    end

    # rubocop:disable Style/DoubleNegation
    def available?
      !!(
        (model.start_datetime && !future?) &&
          (model.end_datetime && !over?)
      )
    end
    # rubocop:enable Style/DoubleNegation

    def over?
      model.end_datetime < Time.now
    end

    def future?
      model.start_datetime > Time.now
    end

    def expiring?
      available? && model.end_datetime < 12.hours.from_now
    end

    def user_is_winning_bidder?(user)
      return false unless current_bid?
      user.id == winning_bidder_id
    end

    def winning_bidder
      winning_bid.bidder rescue nil
    end

    def winning_bid
      return single_bid_winning_bid if single_bid?
      return multi_bid_winning_bid  if multi_bid?
    end

    def winning_bidder_id
      winning_bid.bidder_id rescue nil
    end

    def winning_bid_id
      winning_bid.id rescue nil
    end

    def single_bid?
      model.type == 'single_bid'
    end

    def multi_bid?
      model.type == 'multi_bid'
    end

    def single_bid_winning_bid
      return nil if available?
      return lowest_bids.first if lowest_bids.length == 1
      return lowest_bids.sort_by(&:created_at).first
    end

    def multi_bid_winning_bid
      current_bid
    end

    def lowest_bids
      bids.select {|b| b.amount == lowest_amount }
    end

    def lowest_amount
      bids.sort_by(&:amount).first.amount
    end

    def auction_user(user)
      return Presenter::AuctionUser::Null.new if user.nil?

      @auction_users ||= {}
      @auction_users[user.id] ||= Presenter::AuctionUser.new(bids, user)
    end

    def user_is_bidder?(user)
      auction_user(user).has_bid?
    end

    def user_bids(user)
      auction_user(user).bids
    end

    def lowest_user_bid(user)
      auction_user(user).lowest_bid
    end

    def lowest_user_bid_amount(user)
      auction_user(user).lowest_bid_amount
    end

    def html_description
      return '' if description.blank?
      markdown.render(description)
    end

    def html_summary
      return '' if summary.blank?
      markdown.render(summary)
    end

    delegate :status, :label_class, :label, :tag_data_value_status, :tag_data_label_2, :tag_data_value_2,
             to: :status_presenter

    def human_start_time
      if start_datetime < Time.now
        # this method comes from the included date helpers
        "#{distance_of_time_in_words(Time.now, start_datetime)} ago"
      else
        "in #{distance_of_time_in_words(Time.now, start_datetime)}"
      end
    end

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
      "::Presenter::AuctionStatus::#{status_name}".constantize
    end

    def status_presenter
      @status_presenter ||= status_presenter_class.new(self)
    end

    def current_bid_record
      @current_bid_record ||= bids.sort_by {|bid| [bid.amount, bid.created_at, bid.id] }.first
    end

    def markdown
      # FIXME: Do we want the lax_spacing?
      @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                            no_intra_emphasis: true,
                                            autolink: true,
                                            tables: true,
                                            fenced_code_blocks: true,
                                            lax_spacing: true)
    end

    def time_in_human(time)
      distance = distance_of_time_in_words(Time.now, time)
      if time < Time.now
        "#{distance} ago"
      else
        "in #{distance}"
      end
    end

    def model
      @auction
    end
  end
end
