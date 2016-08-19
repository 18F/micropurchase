class AuctionListItem
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def auction_title_partial
    'auctions/title'
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
    status_presenter.relative_time
  end

  def winning_bid_amount_as_currency
    if auction.lowest_bid
      Currency.new(auction.lowest_bid.amount).to_s
    else
      'No bids'
    end
  end

  def status_presenter
    @_status_presenter ||= StatusPresenterFactory.new(auction).create
  end

  private

  def for_small_business?
    AuctionThreshold.new(auction).small_business?
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
