class AdminAuctionStatusPresenter::Accepted < AdminAuctionStatusPresenter::Base
  def header
    I18n.t('statuses.admin_auction_status_presenter.accepted.header')
  end

  def body
    I18n.t(
      'statuses.admin_auction_status_presenter.accepted.body',
      accepted_at: accepted_at,
      winner_email: winner.email
    )
  end

  private

  def accepted_at
    DcTimePresenter.convert_and_format(auction.accepted_at)
  end
end
