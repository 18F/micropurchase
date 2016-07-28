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

  def starting_price
    Currency.new(auction.start_price).to_s
  end

  def eligibility_label
    if for_small_business?
      'Small-business only'
    else
      'SAM.gov only'
    end
  end

  def skills
    auction.sorted_skill_names.join(', ')
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
    if over?
      'auctions/over_winning_bid_details'
    elsif auction.type == 'reverse' && available? && auction.bids.any?
      'auctions/winning_bid_details'
    else # sealed or reverse with no bids or future
      'auctions/starting_price'
    end
  end

  def relative_time
    status_presenter.relative_time
  end

  def winning_bid_amount_as_currency
    if auction.lowest_bid
      Currency.new(auction.lowest_bid.amount).to_s
    else
      'No bids'
    end
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
