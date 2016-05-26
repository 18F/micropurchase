class Admin::AuctionListItem
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

  def availability_partial
    if available?
      'admin/auctions/available'
    else
      'admin/auctions/not_live'
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
