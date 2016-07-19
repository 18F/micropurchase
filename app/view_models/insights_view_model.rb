class InsightsViewModel
  def active_count
    AuctionQuery.new.active_auction_count
  end

  def upcoming_count
    AuctionQuery.new.upcoming_auction_count
  end

  def hero_metrics
    [
      total_auction_stat,
      accepted_auction_stat,
      unique_winners_stat,
      average_bids_stat,
      unique_bidders_stat,
      vendors_with_bids_stat,
      average_auction_length_stat,
      { statistic: Statistics::AverageDeliveryTime.new.to_s, label: 'average delivery time' },
      { statistic: Statistics::AverageStartingPrice.new.to_s, label: 'average starting price' },
      average_winning_bid_stat,
      small_business_stat,
      { statistic: UserQuery.new.in_sam.count, label: 'Sam.gov qualified vendors' }
    ]
  end

  def sorted_skills_count
    skills_count.sort_by { |skill_count| -skill_count.evaluated_auction_count }
  end

  private

  def skills_count
    Skill.all.map { |skill| SkillPresenter.new(skill) }
  end

  def total_auction_stat
    {
      statistic: accepted_and_rejected_auction_count,
      label: 'total auctions',
      href: 'chart-bids-by-auction'
    }
  end

  def accepted_auction_stat
    {
      statistic: accepted_auctions_count,
      label: 'successful delieries',
      label_stat: "(#{accepted_auction_percent} success rate)"
    }
  end

  def unique_winners_stat
    {
      statistic: unique_auction_winners,
      label: 'unique auction winners',
      href: 'chart-winning-bid'
    }
  end

  def average_bids_stat
    {
      statistic: Statistics::AverageBidsPerAuction.new.to_s,
      label: 'bids/auction',
      href: 'chart4'
    }
  end

  def unique_bidders_stat
    {
      statistic: Statistics::UniqueBiddersPerAuction.new.to_s,
      label: 'unique bidders per auction'
    }
  end

  def vendors_with_bids_stat
    {
      statistic: UserQuery.new.with_bids.count,
      href: 'agency-savings',
      label: 'vendors who have placed bids'
    }
  end

  def average_auction_length_stat
    {
      statistic: Statistics::AverageAuctionLength.new.to_s,
      href: 'auction-length',
      label: 'average auction length'
    }
  end

  def average_winning_bid_stat
    {
      href: 'chart-winning-bid',
      statistic: Statistics::AverageWinningBid.new.to_s,
      label: 'average winning bid'
    }
  end

  def small_business_stat
    {
      statistic: UserQuery.new.small_business.count,
      label: 'small businesses registered'
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
