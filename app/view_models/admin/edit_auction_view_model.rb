class Admin::EditAuctionViewModel
  attr_reader :auction

  def initialize(auction)
    @auction = auction
  end

  def record
    auction
  end

  def delivery_due_partial
    'admin/auctions/delivery_due_at'
  end

  def date_default(field)
    if field == 'paid'
      nil
    else
      dc_time(field).to_date
    end
  end

  def hour_default(field)
    if field == 'paid'
      nil
    else
      dc_time(field).strftime('%l').strip
    end
  end

  def minute_default(field)
    if field == 'paid'
      nil
    else
      dc_time(field).strftime('%M').strip
    end
  end

  def meridiem_default(field)
    dc_time(field).strftime('%p').strip
  end

  def billable_to_options
    ([auction.billable_to] + ClientAccount.all.map(&:to_s)).uniq
  end

  private

  def dc_time(field)
    DcTimePresenter.convert(field_value(field))
  end

  def field_value(field)
    auction.send("#{field}_at") || default_date_time
  end

  def default_date_time
    @_default_date_time ||= DefaultDateTime.new.convert
  end
end
