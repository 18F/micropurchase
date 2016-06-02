class NewBidViewModel
  attr_reader :auction, :current_user

  def initialize(auction:, current_user:)
    @auction = auction
    @current_user = current_user
  end

  def description_partial
    status_presenter.bid_description_partial
  end

  def time_left_partial
    status_presenter.time_left_partial
  end

  def bid_form_partial
    status_presenter.bid_form_partial
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

  def html_description
    MarkdownRender.new(auction.description).to_s
  end

  def distance_of_time
    "#{HumanTime.new(time: auction.ended_at).distance_of_time} left"
  end

  def bids
    auction.bids
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
    auction.bids.where(bidder: current_user).order(amount: :asc).first
  end

  def status_presenter
    @_status_presenter ||= StatusPresenterFactory.new(auction).create
  end
end
