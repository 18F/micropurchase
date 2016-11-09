class Admin::AuctionShowViewModel < Admin::BaseViewModel
  attr_reader :auction, :current_user

  def initialize(auction:, current_user:)
    @auction = auction
    @current_user = current_user
  end

  def csv_report_partial
    if bidding_status.over? && bids?
      'admin/auctions/csv_report'
    else
      'components/null'
    end
  end

  def admin_notes_partial
    if auction.notes.present?
      'admin/auctions/notes'
    else
      'components/null'
    end
  end

  def admin_auction_status_presenter
    AdminAuctionStatusPresenterFactory.new(auction: auction).create
  end

  def bidding_status_presenter
    @_status_presenter ||= BiddingStatusPresenterFactory.new(auction).create
  end

  def admin_data
    {
      'Published status' => auction.published,
      'Share this auction' => share_url,
      'Start date and time' => formatted_date(auction.started_at),
      'End date and time' => formatted_date(auction.ended_at),
      'Delivery deadline date and time' => formatted_date(auction.delivery_due_at),
      'Auction type' => capitalized_type,
      'Eligible vendors' => eligibility_label,
      'Starting price' => Currency.new(auction.start_price).to_s,
      'GitHub repo URL' => auction.github_repo,
      'GitHub issue URL' => auction.issue_url,
      'Accepted at' => formatted_date(auction.accepted_at),
      'Delivery URL' => auction.delivery_url,
      'Customer' => customer.agency_name,
      'Billable to' => auction.billable_to,
      'Purchase card' => auction.purchase_card,
      'Paid at' => formatted_date(auction.paid_at)
    }.merge(c2_fields)
  end

  def id
    auction.id
  end

  def title
    auction.title
  end

  def relative_time
    bidding_status_presenter.relative_time
  end

  def veiled_bids
    auction.bids.map do |bid|
      Admin::BidListItem.new(bid: bid, user: current_user)
    end
  end

  def html_description
    MarkdownRender.new(auction.description).to_s
  end

  def html_summary
    MarkdownRender.new(auction.summary).to_s
  end

  def bid_label
    bidding_status_presenter.bid_label(current_user)
  end

  private

  def bidding_status
    @_bidding_status ||= BiddingStatus.new(auction)
  end

  def rules
    @_rules ||= RulesFactory.new(auction).create
  end

  def eligibility_label
    EligibilityFactory.new(auction).create.label
  end

  def share_url
    if auction.unpublished?
      AuctionPreviewUrl.new(auction: auction)
    else
      url = AuctionUrl.new(auction: auction)
      Url.new(link_text: url, path_name: 'auction', params: { id: auction.id })
    end
  end

  def capitalized_type
    auction.type.dasherize.capitalize
  end

  def c2_fields
    if auction.purchase_card == 'default'
      {
        'C2 proposal URL' => auction.c2_proposal_url,
        'C2 approval status' => auction.c2_status,
        'Receipt URL' => receipt_url
      }
    else
      { }
    end
  end

  def bids?
    auction.bids.any?
  end

  def customer
    auction.customer || NullCustomer.new
  end

  def formatted_date(date)
    DcTimePresenter.convert_and_format(date)
  end

  def receipt_url
    if auction.payment_confirmed?
      ReceiptUrl.new(auction).to_s
    else
      "Winning vendor has not confirmed payment"
    end
  end
end
