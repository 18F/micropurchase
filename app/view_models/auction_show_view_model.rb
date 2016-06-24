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
    auction.type.dasherize.capitalize
  end

  def issue_url
    auction.issue_url
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

  def bids_count
    auction.bids.count
  end

  def rules_path
    "/auctions/rules/#{auction.type.dasherize}"
  end

  def status_text
    status_presenter.status_text
  end

  def eligibility_label
    if AuctionThreshold.new(auction).small_business?
      'Small-business only'
    else
      'SAM.gov only'
    end
  end

  def bid_form_partial
    if show_bid_form?
      'auctions/bid_form'
    else
      'components/null'
    end
  end

  def bid_form_prompt
    Currency.new(rules.max_allowed_bid).to_s
  end

  def bid_status
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

  def start_label
    status_presenter.start_label
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

  def formatted_paid_at
    DcTimePresenter.convert_and_format(auction.paid_at)
  end

  def paid_at_partial
    if auction.paid_at.nil?
      'components/null'
    else
      'auctions/paid_at'
    end
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

  def bid_flash_partial
    if auction.type == 'reverse' && (over? || available_and_user_is_bidder?)
      'auctions/bid_status_header'
    else
      'components/null'
    end
  end

  def html_description
    MarkdownRender.new(auction.description).to_s
  end

  def deadline_label
    status_presenter.deadline_label
  end

  def bid_status_class(flash)
    BidStatusFlashFactory.new(auction: auction, flash: flash, user: current_user).create
  end

  def admin_edit_auction_partial
    current_user.decorate.admin_edit_auction_partial
  end

  private

  def user_bid_amount_as_currency
    Currency.new(lowest_user_bid_amount).to_s
  end

  def lowest_bidder_name
    auction.lowest_bid.bidder.name
  end

  def available_and_user_is_bidder?
    available? && user_bids.any?
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

  def show_bid_form?
    if available? && current_user.is_a?(Guest)
      true
    else
      rules.user_can_bid?(current_user)
    end
  end

  def over?
    auction_status.over?
  end

  def available?
    auction_status.available?
  end

  def auction_status
    AuctionStatus.new(auction)
  end

  def rules
    @_rules ||= RulesFactory.new(auction).create
  end
end
