class Admin::NewAuctionViewModel
  def new_record
    Auction.new
  end

  def new_record?
    true
  end

  def date_default(_field)
    default_date_time.convert.to_date
  end

  def hour_default(_field)
    default_date_time.hour
  end

  def minute_default(_field)
    default_date_time.minute
  end

  def meridiem_default(_field)
    default_date_time.meridiem
  end

  private

  def default_date_time
    DefaultDateTime.new
  end
end
