class AuctionsClosedWithinLastTwentyFourHoursFinder
  def perform
    today = Time.current.to_date
    last_24_hours = today - 24.hours
    next_24_hours = today + 24.hours

    Auction.where(ended_at: last_24_hours..next_24_hours)
  end
end
