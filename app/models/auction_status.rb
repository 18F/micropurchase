class AuctionStatus
  def initialize(auction)
    @auction = auction
  end

  def available?
    started_in_past? && ends_in_future?
  end

  def over?
    auction.end_datetime.present? && ended_in_past?
  end

  def future?
    auction.start_datetime.nil? || starts_in_future?
  end

  def expiring?
    available? && auction.end_datetime < (Time.current + 12.hours)
  end

  private

  attr_reader :auction

  def ends_in_future?
    auction.end_datetime > Time.current
  end

  def ended_in_past?
    auction.end_datetime < Time.current
  end

  def starts_in_future?
    auction.start_datetime > Time.current
  end

  def started_in_past?
    auction.start_datetime < Time.current
  end
end
