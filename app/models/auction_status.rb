class AuctionStatus
  def initialize(auction)
    @auction = auction
  end

  def available?
    published? && started_in_past? && ends_in_future?
  end

  def over?
    auction.ended_at.present? && ended_in_past?
  end

  def future?
    auction.started_at.nil? || starts_in_future?
  end

  def expiring?
    available? && auction.ended_at < (Time.current + 12.hours)
  end

  def work_in_progress?
    auction.delivery_url.present? && auction.pending_delivery?
  end

  private

  attr_reader :auction

  def published?
    auction.published?
  end

  def ends_in_future?
    auction.ended_at > Time.current
  end

  def ended_in_past?
    auction.ended_at < Time.current
  end

  def starts_in_future?
    auction.started_at > Time.current
  end

  def started_in_past?
    auction.started_at < Time.current
  end
end
