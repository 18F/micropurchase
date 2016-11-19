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

  def auction_title_partial
    if current_user.decorate.admin?
      'admin/auctions/title'
    else
      'auctions/title'
    end
  end

  def html_summary
    MarkdownRender.new(auction.summary).to_s
  end

  def rules_label
    rules.rules_label
  end

  def rules_route
    rules.rules_route
  end

  def starting_price
    Currency.new(auction.start_price).to_s
  end

  def eligibility_label
    EligibilityFactory.new(auction).create.label
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
    bidding_status_presenter.relative_time
  end

  def winning_bid_amount_as_currency
    if auction.lowest_bid
      Currency.new(auction.lowest_bid.amount).to_s
    else
      # TODO: move to i18n
      'There are no bids'
    end
  end

  def bidding_status_presenter
    @_status_presenter ||= BiddingStatusPresenterFactory.new(auction).create
  end

  private

  def for_small_business?
    AuctionThreshold.new(auction).small_business?
  end

  def available?
    bidding_status.available?
  end

  def over?
    bidding_status.over?
  end

  def bidding_status
    BiddingStatus.new(auction)
  end

  def rules
    @_rules ||= RulesFactory.new(auction).create
  end
end
