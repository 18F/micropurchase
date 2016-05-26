class AuctionListItem
  attr_reader :auction, :current_user

  def initialize(auction:, current_user:)
    @auction = auction
    @current_user = current_user
  end

  def title
    auction.title
  end

  def id
    auction.id
  end

  def bids
    auction.bids
  end

  def html_summary
    return '' if auction.summary.blank?
    auction.summary
  end

  def label
    status_presenter.label
  end

  def label_class
    status_presenter.label_class
  end

  def capitalized_formatted_type
    if auction.type == "single_bid"
      'single-bid'
    else
      'multi-bid'
    end.capitalize
  end

  def eligibility_label
    if for_small_business?
      'Small-business only'
    else
      'SAM.gov only'
    end
  end

  def project_href
    auction.github_repo
  end

  def project_label
    auction.github_repo.sub('https://github.com/', '')
  end

  def available?
    auction_status.available?
  end

  def bid_button_partial
    if current_user_can_bid?
      'auctions/bid_button'
    else
      'components/null'
    end
  end

  def item_footer_partial
    if available?
      'auctions/bids_and_form'
    else
      'auctions/winning_bid'
    end
  end

  def winning_bid_partial
    if auction.type == 'multi_bid'
      'auctions/multi_bid/winning_bid'
    elsif auction.type == 'single_bid'
      'auctions/multi_bid/winning_bid'
    end
  end

  def start_time_partial
    if over?
      'components/null'
    else
      'auctions/start_time'
    end
  end

  def index_bid_summary_partial
    if auction.type == 'multi_bid' && auction.bids.any?
      'auctions/current_bid'
    elsif auction.type == 'multi_bid'
      'auctions/no_bids'
    elsif user_is_bidder?
      'auctions/user_is_bidder'
    else
      'auctions/bids_hidden'
    end
  end

  def over?
    auction_status.over?
  end

  def relative_start_time
    HumanTime.new(time: auction.started_at).relative_start_time
  end

  def relative_time_left
    HumanTime.new(time: auction.ended_at).relative_time_left
  end

  def highlighted_bid_amount_as_currency
    Currency.new(highlighted_bid.amount).to_s
  end

  def user_is_bidder?
    user_bids.any?
  end

  def user_is_winning_bidder?
    auction.bids.any? && lowest_user_bid == auction.lowest_bid
  end

  def user_bid_amount_as_currency
    Currency.new(lowest_user_bid_amount).to_s
  end

  def github_repo_stripped
    auction.github_repo.gsub('https://github.com/', '')
  end

  private

  def current_user_can_bid?
    if current_user.is_a?(Guest)
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

  def lowest_user_bid_amount
    lowest_user_bid.amount
  end

  def lowest_user_bid
    user_bids.order(amount: :asc).first
  end

  def user_bids
    auction.bids.where(bidder: current_user)
  end

  def highlighted_bid
    @_highlighted_bid ||=
      HighlightedBid.new(auction: auction, user: current_user).find
  end

  def for_small_business?
    StartPriceThresholds.new(auction.start_price).small_business?
  end

  def status_presenter
    status_presenter_class.new(auction)
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

  def auction_status
    AuctionStatus.new(auction)
  end
end
