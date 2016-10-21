class AuctionShowViewModel
  attr_reader :auction, :current_user

  def initialize(auction:, current_user:, bid_error: nil)
    @auction = auction
    @current_user = current_user
    @bid_error = bid_error
  end

  def id
    auction.id
  end

  def title
    auction.title
  end

  def admin_edit_auction_partial
    current_user.decorate.admin_edit_auction_partial
  end

  def summary
    auction.summary
  end

  def html_description
    MarkdownRender.new(auction.description).to_s
  end

  def skills
    auction.sorted_skill_names.to_sentence
  end

  def auction_data
    {
      bidding_status_presenter.start_label => formatted_date(auction.started_at),
      bidding_status_presenter.deadline_label => formatted_ended_at,
      'Delivery deadline' => formatted_date(auction.delivery_due_at),
      'Eligible vendors' => eligibility_label,
      'Customer' => customer.agency_name
    }.compact
  end

  def issue_url
    auction.issue_url
  end

  def rules_path
    rules.path
  end

  def capitalized_type
    auction.type.dasherize.capitalize
  end

  def bidding_status_presenter
    @_status_presenter ||= BiddingStatusPresenterFactory.new(auction).create
  end

  def bid_status_presenter
    @_bid_status_presenter ||=
      BidStatusPresenterFactory.new(auction: auction,
                                    user: current_user,
                                    bid_error: @bid_error).create
  end

  def bid_label
    if available?
      bidding_status_presenter.bid_label(current_user)
    elsif over? && auction.bids.any?
      "Winning bid (#{lowest_bidder_name}): #{highlighted_bid_amount_as_currency}"
    elsif user_bids.any?
      "Your bid: #{Currency.new(lowest_user_bid_amount)}"
    elsif auction.bids.any?
      "Current bid: #{highlighted_bid_amount_as_currency}"
    elsif future?
      "Starting price: #{Currency.new(auction.start_price)}"
    else
      ""
    end
  end

  def paid_at_partial
    if auction.paid_at.nil?
      'components/null'
    else
      'auctions/paid_at'
    end
  end

  def accepted_at_partial
    if auction.accepted_at.nil?
      'components/null'
    else
      'auctions/accepted_at'
    end
  end

  def formatted_ended_at
    formatted_date(auction.ended_at)
  end

  def formatted_paid_at
    formatted_date(auction.paid_at)
  end

  def formatted_accepted_at
    formatted_date(auction.accepted_at)
  end

  def tag_data_value_status
    bidding_status_presenter.tag_data_value_status
  end

  def tag_data_label_2
    bidding_status_presenter.tag_data_label_2
  end

  def tag_data_value_2
    bidding_status_presenter.tag_data_value_2
  end

  def highlighted_bid_amount_as_currency
    Currency.new(rules.highlighted_bid(current_user).amount).to_s
  end

  def max_allowed_bid_as_currency
    Currency.new(rules.max_allowed_bid).to_s
  end

  def relative_time
    bidding_status_presenter.relative_time
  end

  def sealed_bids_partial
    if available? && auction.type == 'sealed_bid'
      'bids/sealed'
    else
      'components/null'
    end
  end

  def veiled_bids
    bids = rules.veiled_bids(current_user)
    bids.map { |bid| BidListItem.new(bid: bid, user: current_user) }
  end

  def nofollow_partial
    if auction.published?
      'components/null'
    else
      'components/nofollow'
    end
  end

  private

  def lowest_bidder_name
    auction.lowest_bid.bidder_name
  end

  def lowest_user_bid_amount
    user_bids.order(amount: :asc).first.try(:amount)
  end

  def user_bids
    auction.bids.where(bidder: current_user)
  end

  def over?
    bidding_status.over?
  end

  def available?
    bidding_status.available?
  end

  def future?
    bidding_status.future?
  end

  def bidding_status
    @_bidding_status ||= BiddingStatus.new(auction)
  end

  def rules
    @_rules ||= RulesFactory.new(auction).create
  end

  def eligibility_label
    EligibilityFactory.new(auction).create.label
  end

  def customer
    auction.customer || NullCustomer.new
  end

  def formatted_date(date)
    DcTimePresenter.convert_and_format(date)
  end
end
