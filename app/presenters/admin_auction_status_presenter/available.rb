class AdminAuctionStatusPresenter::Available < AdminAuctionStatusPresenter::Base
  def header
    I18n.t('statuses.bid_status_presenter.available.admin.header')
  end

  def body
    if total_bids > 0
      I18n.t(
        'statuses.bid_status_presenter.available.admin.has_bids',
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

  def winner_url
    Url.new(
      link_text: winner_name,
      path_name: 'admin_user',
      params: { id: unmasked_winner_for_admin.id }
    )
  end

  def winner_name
    unmasked_winner_for_admin.name || unmasked_winner_for_admin.github_login
  end

  def unmasked_winner_for_admin
    @_bidder ||= auction.lowest_bid.bidder
  end

  def end_date
    DcTimePresenter.convert_and_format(auction.ended_at)
  end
end
