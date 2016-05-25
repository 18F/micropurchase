class BidsNewViewModel
  attr_reader :auction, :current_user

  def initialize(auction:, current_user:)
    @auction = auction
    @current_user = current_user
  end

  def description_partial
    if available?
      'bids/available_bid_description'
    else
      'bids/over_bid_description'
    end
  end

  def time_left_partial
    if available?
      'bids/relative_time_left'
    else
      'components/null'
    end
  end

  def form_partial
    if available?
      'bids/form'
    else
      'bids/closed'
    end
  end

  def highlighted_bid_info_partial
    if auction.type == 'single_bid'
      'bids/start_price'
    else
      'bids/highlighted_bid_info'
    end
  end

  def bid_status_partial
    if user_is_winning_bidder?
      'bids/winning_bidder'
    elsif auction.bids.any?
      'bids/not_winning_bidder'
    else
      'bids/no_bids'
    end
  end

  def new_bid
    Bid.new
  end

  def id
    auction.id
  end

  def title
    auction.title
  end

  def ended_at
    auction.ended_at
  end

  def start_price_as_currency
    Currency.new(auction.start_price).to_s
  end

  def highlighted_bid_amount_as_currency
    Currency.new(highlighted_bid.amount).to_s
  end

  def tag_data_value_status
    status_presenter.tag_data_value_status
  end

  def tag_data_label_2
    status_presenter.tag_data_label_2
  end

  def tag_data_value_2
    status_presenter.tag_data_value_2
  end

  def available?
    AuctionStatus.new(auction).available?
  end

  def html_description
    return '' if auction.description.blank?
    MarkdownRender.new(auction.description).to_s.html_safe
  end

  def relative_time_left
    HumanTime.new(time: auction.ended_at).relative_time_left
  end

  def bids
    auction.bids
  end

  def show_bids?
    if auction.type == 'single_bid' && available?
      false
    else
      true
    end
  end

  private

  def highlighted_bid
    @_highlighted_bid ||=
      HighlightedBid.new(auction: auction, user: current_user).find
  end

  def user_is_winning_bidder?
    auction.bids.any? && lowest_user_bid == auction.lowest_bid
  end

  def lowest_user_bid
    user_bids.order(amount: :asc).first
  end

  def user_is_bidder?
    user_bids.any?
  end

  def user_bids
    auction.bids.where(bidder: current_user)
  end

  def status_presenter
    @status_presenter ||= status_presenter_class.new(self)
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

  def over?
    auction_status.over?
  end

  def auction_status
    AuctionStatus.new(auction)
  end
end
