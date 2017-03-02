class AdminAuctionStatusPresenter::Rejected < AdminAuctionStatusPresenter::Base
  def header
    I18n.t('statuses.admin_auction_status_presenter.rejected.header')
  end

  def body
    I18n.t(
      'statuses.admin_auction_status_presenter.rejected.body',
      delivery_url: auction.delivery_url,
      rejected_at: rejected_at,
      winner_name: winner_name
    )
  end

  def self.relevant?(status)
    status.rejected?
  end

  private

  def rejected_at
    DcTimePresenter.convert_and_format(auction.rejected_at)
  end
end
