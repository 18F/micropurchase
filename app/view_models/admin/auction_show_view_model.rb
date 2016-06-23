class Admin::AuctionShowViewModel < Admin::BaseViewModel
  attr_reader :auction

  def initialize(auction)
    @auction = auction
  end

  def id
    auction.id
  end

  def title
    auction.title
  end

  def billable_to
    auction.billable_to
  end

  def status_partial
    if over?
      'admin/auctions/csv_report'
    else
      'components/null'
    end
  end

  def bids_partial
    if auction.bids.any?
      'admin/auctions/bids'
    else
      'components/null'
    end
  end

  def bids
    auction.bids.map { |bid| Admin::BidListItem.new(bid) }
  end

  def started_at
    formatted_time(auction.started_at)
  end

  def ended_at
    formatted_time(auction.ended_at)
  end

  def paid_at
    formatted_time(auction.paid_at)
  end

  def html_summary
    return '' if auction.summary.blank?
    MarkdownRender.new(auction.summary).to_s
  end

  def html_description
    return '' if auction.description.blank?
    MarkdownRender.new(auction.description).to_s
  end

  private

  def available?
    auction_status.available?
  end

  def over?
    auction_status.over?
  end

  def auction_status
    AuctionStatus.new(auction)
  end

  def formatted_time(time)
    DcTimePresenter.convert_and_format(time)
  end
end
