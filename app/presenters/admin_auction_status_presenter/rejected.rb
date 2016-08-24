class AdminAuctionStatusPresenter::Rejected < AdminAuctionStatusPresenter::Base
  def header
    I18n.t('statuses.c2_presenter.rejected.header')
  end

  def body
    I18n.t(
      'statuses.c2_presenter.rejected.body',
      delivery_url: auction.delivery_url,
      rejected_at: rejected_at,
      winner_email: winner.email
    )
  end

  private

  def rejected_at
    DcTimePresenter.convert_and_format(auction.rejected_at)
  end
end
