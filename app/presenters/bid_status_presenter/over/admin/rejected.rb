class BidStatusPresenter::Over::Admin::Rejected < BidStatusPresenter::Base
  def header
    I18n.t('statuses.bid_status_presenter.over.admin.rejected.header')
  end

  def body
    I18n.t(
      'statuses.bid_status_presenter.over.admin.rejected.body',
      delivery_url: auction.delivery_url,
      rejected_at: rejected_at,
      winner_email: winner.email
    )
  end

  private

  def winner
    WinningBid.new(auction).find.bidder
  end

  def rejected_at
    DcTimePresenter.convert_and_format(auction.rejected_at)
  end
end
