class AuctionListItem
  attr_reader :auction, :current_user

  def initialize(auction:, current_user:)
    @auction = auction
    @current_user = current_user
  end

  def label
    status_presenter.label
  end

  def label_class
    status_presenter.label_class
  end

  def title
    auction.title
  end

  def id
    auction.id
  end

  def html_summary
    MarkdownRender.new(auction.summary).to_s
  end

  def capitalized_formatted_type
    auction.type.dasherize.capitalize
  end

  def eligibility_label
    if for_small_business?
      'Small-business only'
    else
      'SAM.gov only'
    end
  end

  def github_repo
    auction.github_repo
  end

  def project_label_partial
    if auction.github_repo
      'auctions/project_label'
    else
      'components/null'
    end
  end

  def project_label
    auction.github_repo.sub('https://github.com/', '')
  end

  def winning_bid_partial
    if over? && !auction.bids.any?
      'auctions/no_bids'
    elsif auction.type == 'multi_bid' && over?
      'auctions/over_winning_bid_details'
    elsif auction.type == 'single_bid' && over?
      'auctions/over_with_bids'
    elsif auction.type == 'multi_bid' && available?
      auction_available_bids_partial
    elsif auction.type == 'single_bid' && available?
      single_bid_bidder_partial
    else # future
      'components/null'
    end
  end

  def auction_available_bids_partial
    if auction.bids.any?
      'auctions/winning_bid_details'
    else
      'auctions/no_bids_yet'
    end
  end

  def single_bid_bidder_partial
    if user_is_bidder?
      'auctions/single_bid_user_is_bidder'
    else
      'components/null'
    end
  end

  def winning_bidder_partial
    if user_is_winning_bidder? && auction.type == 'single_bid'
      'auctions/single_bid_user_is_winning_bidder'
    elsif user_is_winning_bidder? && auction.type == 'multi_bid'
      'auctions/multi_bid_user_is_winning_bidder'
    else
      'auctions/user_is_not_winning_bidder'
    end
  end

  def user_is_bidder_partial
    if user_is_bidder?
      'auctions/user_is_bidder'
    else
      'components/null'
    end
  end

  def over_user_is_winner_class
    if !user_is_winning_bidder?
      'issue-current-bid-long'
    else
      ''
    end
  end

  def current_winning_bidder_partial
    if user_is_winning_bidder? && auction.type == 'multi_bid'
      'auctions/user_is_current_winning_bidder'
    else
      'auctions/user_is_not_current_winning_bidder'
    end
  end

  def relative_time
    status_presenter.relative_time
  end

  def highlighted_bid_amount_as_currency
    Currency.new(highlighted_bid.amount).to_s
  end

  def user_bid_amount_as_currency
    Currency.new(lowest_user_bid.amount).to_s
  end

  private

  def user_is_bidder?
    user_bids.any?
  end

  def user_is_winning_bidder?
    auction.bids.any? && lowest_user_bid == auction.lowest_bid
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
    AuctionThreshold.new(auction).small_business?
  end

  def status_presenter
    @_status_presenter ||= StatusPresenterFactory.new(auction).create
  end

  def available?
    auction_status.available?
  end

  def over?
    auction_status.over?
  end

  def auction_status
    AuctionStatus.new(auction)
  end
end
