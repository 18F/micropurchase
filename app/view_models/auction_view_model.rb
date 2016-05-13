class AuctionViewModel < Struct.new(:current_user, :auction_record)
  include ActionView::Helpers::NumberHelper

  delegate(
    :auction_rules_href,
    :bid_count,
    :bids,
    :bids?,
    :created_at,
    :delivery_deadline,
    :eligibility,
    :end_datetime,
    :formatted_delivery_deadline,
    :formatted_end_time,
    :formatted_start_time,
    :formatted_type,
    :highlighted_bid_label,
    :html_description,
    :html_description,
    :html_summary,
    :relative_time_left,
    :relative_start_time,
    :id,
    :issue_url,
    :partial_path,
    :read_attribute_for_serialization,
    :show_bids?,
    :small_business?,
    :start_datetime,
    :start_price,
    :summary,
    :title,
    :to_param,
    :type,
    :updated_at,
    :lowest_bid,
    :veiled_bids,
    to: :auction
  )

  delegate(
    :amount,
    to: :highlighted_bid,
    prefix: true
  )

  delegate(
    :label,
    :label_class,
    :status_text,
    :tag_data_label_2,
    :tag_data_value_status,
    :tag_data_value_2,
    to: :status_presenter
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

  def highlighted_bid_amount_as_currency
    number_to_currency(highlighted_bid_amount)
  end

  def highlighted_bidder_name
    highlighted_bid.bidder_name
  end

  def user_is_bidder?
    user_bids_obj.bid?
  end

  def user_is_winning_bidder?
    # FIXME: who is calling this?
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

  private

  def auction
    @auction ||= AuctionPresenter.new(auction_record)
  end

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
    "::AuctionStatus::#{status_name}ViewModel".constantize
  end

  def expiring?
    auction_status.expiring?
  end

  def future?
    auction_status.future?
  end

  def available?
    auction_status.available?
  end

  def over?
    auction_status.over?
  end

  def auction_status
    AuctionStatus.new(auction_record)
  end

  def status_presenter
    @status_presenter ||= status_presenter_class.new(self)
  end

  def user_bids_obj
    if current_user.nil?
      UserBidsViewModel::Null.new
    else
      @user_bids_obj ||= UserBidsViewModel.new(current_user, auction.bids)
    end
  end
end
