class AdminAuctionStatusPresenter::NoBids < AdminAuctionStatusPresenter::Base
  def header
    I18n.t('statuses.admin_auction_status_presenter.no_bids.header')
  end

  def body
    I18n.t(
      'statuses.admin_auction_status_presenter.no_bids.body',
      end_date: end_date
    )
  end

  def self.relevant?(status)
    status.over_and_no_bids?
  end

  private

  def end_date
    DcTimePresenter.convert_and_format(auction.ended_at)
  end
end
