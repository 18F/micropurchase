class AdminAuctionStatusPresenter::ReadyToPublish < AdminAuctionStatusPresenter::Base
  def header
    I18n.t('statuses.admin_auction_status_presenter.future.unpublished.header')
  end

  def body
    I18n.t('statuses.admin_auction_status_presenter.future.unpublished.body')
  end

  def action_partial
    'admin/auctions/publish_auction'
  end

  def auction_id
    auction.id
  end

  def date(field)
    dc_time(field).to_date
  end

  def hour_default(field)
    dc_time(field).strftime('%l').strip
  end

  def minute_default(field)
    dc_time(field).strftime('%M').strip
  end

  def meridiem_default(field)
    dc_time(field).strftime('%p').strip
  end

  private

  def dc_time(field)
    DcTimePresenter.convert(field_value(field))
  end

  def field_value(field)
    auction.send("#{field}_at")
  end
end
