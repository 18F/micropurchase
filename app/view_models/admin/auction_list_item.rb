class Admin::AuctionListItem
  attr_reader :auction

  def initialize(auction)
    @auction = auction
  end

  def id
    auction.id
  end

  def drafts_nav_class
    'usa-current'
  end

  def title
    auction.title
  end

  def availability
    if available?
      "Available"
    else
      "Not live"
    end
  end

  def formatted_start_time
    DcTimePresenter.convert_and_format(auction.started_at)
  end

  def formatted_end_time
    DcTimePresenter.convert_and_format(auction.ended_at)
  end

  private

  def available?
    AuctionStatus.new(auction).available?
  end
end
