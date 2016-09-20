class AdminAuctionStatusPresenter::Available < AdminAuctionStatusPresenter::Base
  def header
    I18n.t('statuses.bid_status_presenter.available.admin.header')
  end

  def body
    if total_bids > 0
      I18n.t('statuses.bid_status_presenter.available.admin.has_bids',
             end_date: end_date,
             winner_url: winner_url,
             total_bids: total_bids
            )
    else
      I18n.t('statuses.bid_status_presenter.available.admin.body', end_date: end_date)
    end
  end

  private

  def total_bids
    auction.bids.count
  end

  # winning_bid is a NullBid when sealed-bid auctions are available
  def winner
    auction.lowest_bid.bidder
  end

  private

  def end_date
    DcTimePresenter.convert_and_format(auction.ended_at)
  end
end
