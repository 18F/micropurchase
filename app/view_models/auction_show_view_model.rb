class AuctionShowViewModel
  attr_reader :auction, :current_user

  def initialize(auction:, current_user:)
    @auction = auction
    @current_user = current_user
  end

  def id
    auction.id
  end

  def title
    auction.title
  end

  def summary
    auction.summary
  end

  def capitalized_type
    auction.type.capitalize
  end

  def issue_url
    auction.issue_url
  end

  def rules_link_text
    "Rules for #{formatted_type} auctions"
  end

  def rules_path
    if auction.type == 'single_bid'
      '/auction/rules/single-bid'
    else
      '/auctions/rules/multi-bid'
    end
  end

  def status_text
    status_presenter.status_text
  end

  def eligibility_label
    if for_small_business?
      'Small-business only'
    else
      'SAM.gov only'
    end
  end

  def bid_status_header
    if over? && auction.bids.any?
      "Winning bid (#{auction.lowest_bid.bidder.name}):"
    elsif auction.type == 'single_bid'
      'Your bid:'
    else
      'Current bid:'
    end
  end

  def bid_status_partial
    if over? && auction.bids.any?
      'auctions/over_bid_amount'
    elsif auction.type == 'single_bid'
      'auctions/user_bid_amount'
    else
      'auctions/highlighted_bid_amount'
    end
  end

  def start_label
    if over?
      "Auction started at:"
    else
      "Bid start time:"
    end
  end

  def formatted_start_time
    DcTimePresenter.convert_and_format(auction.started_at)
  end

  def formatted_end_time
    DcTimePresenter.convert_and_format(auction.ended_at)
  end

  def formatted_delivery_due_at
    DcTimePresenter.convert_and_format(auction.delivery_due_at)
  end

  def bid_button_partial
    if current_user_can_bid?
      'auctions/show_bid_button'
    else
      'components/null'
    end
  end

  def link_text
    Pluralize.new(number: auction.bids.count, word: 'bid').to_s
  end

  def user_bid_amount_as_currency
    Currency.new(lowest_user_bid_amount).to_s
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

  def distance_of_time
    "#{HumanTime.new(time: auction.ended_at).distance_of_time} left"
  end

  def relative_time
    HumanTime.new(time: auction.started_at).relative_time
  end

  def highlighted_bid_amount_as_currency
    Currency.new(highlighted_bid.amount).to_s
  end

  def winning_bid_amount_as_currency
    Currency.new(auction.lowest_bid.amount).to_s
  end

  def show_bids?
    if auction.type == 'single_bid' && available?
      false
    else
      true
    end
  end

  def bids
    auction.bids
  end

  def start_price
    auction.start_price
  end

  def header_partial(flash)
    if auction.type == 'single_bid'
      'components/null'
    else
      multi_bid_winning_bid_header(flash)
    end
  end

  def html_description
    return '' if auction.description.blank?
    MarkdownRender.new(auction.description).to_s
  end

  def deadline_label
    if over?
      "Auction ended at:"
    else
      "Bid deadline:"
    end
  end

  private

  def user_is_winning_bidder?
    auction.bids.any? && lowest_user_bid == auction.lowest_bid
  end

  def lowest_user_bid_amount
    lowest_user_bid.try(:amount)
  end

  def lowest_user_bid
    user_bids.order(amount: :asc).first
  end

  def formatted_type
    if auction.type == "single_bid"
      'single-bid'
    else
      'multi-bid'
    end
  end

  def multi_bid_winning_bid_header(flash)
    if over?
      auction_over_header
    elsif available? && user_is_bidder?
      auction_available_header(flash)
    else
      'components/null'
    end
  end

  def auction_over_header
    if auction.bids.any? && current_user.is_a?(Guest)
      'auctions/multi_bid/guest_win_header'
    elsif auction.bids.any? && user_is_winning_bidder?
      'auctions/over_user_is_winner_header'
    elsif auction.bids.any? && user_is_bidder?
      'auctions/over_user_is_bidder_header'
    else
      'auctions/no_bids_header'
    end
  end

  def auction_available_header(flash)
    if flash['bid']
      'auctions/bid_submitted_header'
    elsif user_is_winning_bidder?
      'auctions/user_is_winning_bidder_header'
    else
      'auctions/user_is_bidder_header'
    end
  end

  def user_bids
    auction.bids.where(bidder: current_user)
  end

  def highlighted_bid
    @_highlighted_bid ||=
      HighlightedBid.new(auction: auction, user: current_user).find
  end

  def user_is_bidder?
    user_bids.any?
  end

  def status_presenter
    @_status_presenter ||= StatusPresenterFactory.new(auction).create
  end

  def for_small_business?
    AuctionThreshold.new(auction).small_business?
  end

  def current_user_can_bid?
    if auction.type == 'single_bid' && user_bids.any?
      false
    elsif over?
      false
    elsif future?
      false
    elsif current_user.is_a?(Guest)
      true
    elsif !current_user.sam_accepted?
      false
    elsif for_small_business? && current_user.small_business?
      true
    elsif for_small_business? && !current_user.small_business?
      false
    else # not for small business
      true
    end
  end

  def over?
    auction_status.over?
  end

  def available?
    auction_status.available?
  end

  def future?
    auction_status.future?
  end

  def auction_status
    AuctionStatus.new(auction)
  end
end
