class Admin::AuctionShowViewModel < Admin::BaseViewModel
  attr_reader :auction, :current_user

  def initialize(auction:, current_user:)
    @auction = auction
    @current_user = current_user
  end

  def csv_report_partial
    if auction_status.over?
      'admin/auctions/csv_report'
    else
      'components/null'
    end
  end

  def admin_auction_status_partial
    if !auction.pending_delivery? ||
       auction.purchase_card == 'default'
      'auctions/status'
    else
      'components/null'
    end
  end

  def admin_auction_status_presenter
    AdminAuctionStatusPresenterFactory.new(auction: auction).create
  end

  def status_presenter
    @_status_presenter ||= StatusPresenterFactory.new(auction).create
  end

  def admin_data
    {
      'Published status' => auction.published,
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

  def summary
    auction.summary
  end

  def relative_time
    status_presenter.relative_time
  end

  def veiled_bids
    auction.bids.map do |bid|
      Admin::BidListItem.new(bid: bid, user: current_user)
    end
  end

  def distance_of_time_to_now
    "#{HumanTime.new(time: auction.ended_at).distance_of_time_to_now} left"
  end

  def html_description
    MarkdownRender.new(auction.description).to_s
  end

  def html_summary
    MarkdownRender.new(auction.summary).to_s
  end

  def admin_edit_auction_partial
    'auctions/edit_auction_link'
  end

  private

  def eligibility_label
    if AuctionThreshold.new(auction).small_business?
      'Small-business only'
    else
      'SAM.gov only'
    end
  end

  def capitalized_type
    auction.type.dasherize.capitalize
  end

  def c2_fields
    if auction.purchase_card == 'default'
      {
        'C2 proposal URL' => auction.c2_proposal_url,
        'C2 approval status' => auction.c2_status
      }
    else
      { }
    end
  end

  def auction_status
    AuctionStatus.new(auction)
  end

  def customer
    auction.customer || NullCustomer.new
  end

  def formatted_date(date)
    DcTimePresenter.convert_and_format(date)
  end
end
