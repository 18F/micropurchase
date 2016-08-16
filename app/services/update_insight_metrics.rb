class UpdateInsightMetrics
  def perform
    InsightMetric.destroy_all

    metrics.each do |metric|
      insight_metric = InsightMetric.new
      insight_metric.name = metric[:name]
      insight_metric.href = metric[:href]
      insight_metric.label = metric[:label]
      insight_metric.label_statistic = metric[:label_statistic]
      insight_metric.statistic = metric[:statistic]
      insight_metric.save!
    end
  end

  private

  def metrics
    [
      total_auction_count,
      accepted_auction_count,
      unique_winner_count,
      average_bid_count,
      unique_bidders_count,
      vendors_with_bids_count,
      average_auction_length,
      average_delivery_time,
      average_starting_price,
      average_winning_bid,
      small_business_count,
      sam_qualified_vendor_count,
      total_savings,
    ]
  end

  def total_auction_count
    {
      name: 'total_auction_count',
      statistic: accepted_and_rejected_auction_count,
      label: 'total auctions',
      href: 'chart-bids-by-auction'
    }
  end

  def accepted_auction_count
    {
      name: 'accepted_auction_count',
      statistic: accepted_auctions_count,
      label: 'successful deliveries',
      label_statistic: "(#{accepted_auction_percent} success rate)"
    }
  end

  def unique_winner_count
    {
      name: 'unique_winner_count',
      statistic: unique_auction_winners,
      label: 'unique auction winners',
      href: 'chart-winning-bid'
    }
  end

  def average_bid_count
    {
      name: 'average_bid_count',
      statistic: Statistics::AverageBidsPerAuction.new.to_s,
      label: 'bids/auction',
      href: 'chart4'
    }
  end

  def unique_bidders_count
    {
      name: 'unique_bidders_count',
      statistic: Statistics::UniqueBiddersPerAuction.new.to_s,
      label: 'unique bidders per auction'
    }
  end

  def vendors_with_bids_count
    {
      name: 'vendors_with_bids_count',
      statistic: UserQuery.new.with_bids.count,
      href: 'agency-savings',
      label: 'vendors who have placed bids'
    }
  end

  def average_auction_length
    {
      name: 'average_auction_length',
      statistic: Statistics::AverageAuctionLength.new.to_s,
      href: 'auction-length',
      label: 'average auction length'
    }
  end

  def average_delivery_time
    {
      name: 'average_delivery_time',
      statistic: Statistics::AverageDeliveryTime.new.to_s,
      label: 'average delivery time'
    }
  end

  def average_starting_price
    {
      name: 'average_starting_price',
      statistic: Statistics::AverageStartingPrice.new.to_s,
      label: 'average starting price'
    }
  end

  def average_winning_bid
    {
      name: 'average_winning_bid',
      href: 'chart-winning-bid',
      statistic: Statistics::AverageWinningBid.new.to_s,
      label: 'average winning bid'
    }
  end

  def small_business_count
    {
      name: 'small_business_count',
      statistic: UserQuery.new.small_business.count,
      label: 'small businesses registered'
    }
  end

  def sam_qualified_vendor_count
    {
      name: 'sam_qualified_vendor_count',
      statistic: UserQuery.new.in_sam.count,
      label: 'Sam.gov qualified vendors'
    }
  end

  def total_savings
    {
      name: 'total_savings',
      statistic: Statistics::TotalSavings.new.to_s,
      label: 'total savings'
    }
  end

  def unique_auction_winners
    AuctionQuery.new.completed.map do |auction|
      WinningBid.new(auction).find.bidder
    end.uniq.count
  end

  def accepted_auction_percent
    Percent.new(accepted_auctions_count, accepted_and_rejected_auction_count).to_s
  end

  def accepted_and_rejected_auction_count
    @_accepted_and_rejected_auction_count ||=
      accepted_auctions_count + AuctionQuery.new.rejected.count
  end

  def accepted_auctions_count
    @_accepted_auctions_count ||= Auction.delivery_accepted.count
  end
end
