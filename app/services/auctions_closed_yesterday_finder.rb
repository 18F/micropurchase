class AuctionsClosedYesterdayFinder
  def perform
    today = Time.current.to_date
    yesterday = today - 1.day
    beginning_of_yesterday = yesterday.beginning_of_day
    end_of_yesterday = yesterday.end_of_day

    Auction.where(end_datetime: beginning_of_yesterday..end_of_yesterday)
  end
end
