class AdminAuctionStatusPresenter::DefaultPcard::Accepted < AdminAuctionStatusPresenter::Base
  def header
    I18n.t('statuses.admin_auction_status_presenter.default_pcard.accepted.header')
  end

  def body
    I18n.t(
      'statuses.admin_auction_status_presenter.default_pcard.accepted.body',
      accepted_at: accepted_at,
      winner_url: winner_url,
      c2_url: c2_url
    )
  end

  private

  def c2_url
    auction.c2_proposal_url
  end

  def accepted_at
    DcTimePresenter.convert_and_format(auction.accepted_at)
  end
end
