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
      start_label => formatted_date(auction.started_at),
      deadline_label => formatted_ended_at,
      'Delivery deadline' => formatted_date(auction.delivery_due_at),
      'Eligible vendors' => eligibility_label,
      'Customer' => customer_label
    }.compact
  end

  def issue_url
    auction.issue_url
  end

  def rules_path
    "/auctions/rules/#{auction.type.dasherize}"
  end

  def capitalized_type
    auction.type.dasherize.capitalize
  end

  def bid_status
    BidStatusPresenterFactory.new(auction: auction, user: current_user).create
  end

  def bid_status_label
    if over? && auction.bids.any?
      "Winning bid (#{lowest_bidder_name}): #{highlighted_bid_amount_as_currency}"
    elsif user_bids.any?
      "Your bid: #{user_bid_amount_as_currency}"
    elsif auction.bids.any?
      "Current bid: #{highlighted_bid_amount_as_currency}"
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
    status_presenter.tag_data_value_status
  end

  def tag_data_label_2
    status_presenter.tag_data_label_2
  end

  def tag_data_value_2
    status_presenter.tag_data_value_2
  end

  def label
    status_presenter.label
  end

  def label_class
    status_presenter.label_class
  end

  def distance_of_time_to_now
    "#{HumanTime.new(time: auction.ended_at).distance_of_time_to_now} left"
  end

  def highlighted_bid_amount_as_currency
    Currency.new(highlighted_bid.amount).to_s
  end

  def max_allowed_bid_as_currency
    Currency.new(rules.max_allowed_bid).to_s
  end

  def relative_time
    status_presenter.relative_time
  end

  def sealed_bids_partial
    if available? && auction.type == 'sealed_bid'
      'bids/sealed'
    else
      'components/null'
    end
  end

  def veiled_bids
    if available? && auction.type == 'sealed_bid'
      auction.bids.where(bidder: current_user).map do |bid|
        BidListItem.new(bid: bid, user: current_user)
      end
    else
      auction.bids.order(created_at: :desc).map do |bid|
        BidListItem.new(bid: bid, user: current_user)
      end
    end
  end

  private

  def user_not_vendor?
    current_user.is_a?(Guest) || current_user.decorate.admin?
  end

  def reverse_auction_available_user_is_winner?
    auction.type == 'reverse' && available? && user_is_winning_bidder?
  end

  def sealed_bid_auction_user_is_bidder?
    auction.type == 'sealed_bid' && user_bids.any?
  end

  def user_bid_amount_as_currency
    Currency.new(lowest_user_bid_amount).to_s
  end

  def lowest_bidder_name
    auction.lowest_bid.bidder_name
  end

  def user_is_winning_bidder?
    user_bids.any? && lowest_user_bid == auction.lowest_bid
  end

  def lowest_user_bid_amount
    lowest_user_bid.try(:amount)
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

  def status_presenter
    @_status_presenter ||= StatusPresenterFactory.new(auction).create
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

  def rules
    @_rules ||= RulesFactory.new(auction).create
  end

  def start_label
    status_presenter.start_label
  end

  def deadline_label
    status_presenter.deadline_label
  end

  def eligibility_label
    eligibility.label
  end

  def eligibility
    @_eligibility ||= EligibilityFactory.new(auction).create
  end

  def customer_label
    customer.agency_name
  end

  def customer
    auction.customer || NullCustomer.new
  end

  def formatted_date(date)
    DcTimePresenter.convert_and_format(date)
  end
end
