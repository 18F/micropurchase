class BidStatusPresenter::Over::Admin::Accepted < BidStatusPresenter::Base
  def header
    I18n.t('statuses.bid_status_presenter.over.admin.accepted.header')
  end

  def body
    I18n.t(
      'statuses.bid_status_presenter.over.admin.accepted.body',
      accepted_at: accepted_at,
      winner_email: winner.email
    )
  end

  private

  def winner
    WinningBid.new(auction).find.bidder
  end

  def accepted_at
    DcTimePresenter.convert_and_format(auction.accepted_at)
  end
end
