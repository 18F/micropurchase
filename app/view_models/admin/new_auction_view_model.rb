class Admin::NewAuctionViewModel
  def new_record
    Auction.new
  end

  def new_record?
    true
  end

  def hour_default(_field)
    "1"
  end

  def minute_default(_field)
    "00"
  end

  def meridiem_default(_field)
    "PM"
  end

  def date_default(_field)
    DcTimePresenter.convert(Date.today).to_date
  end
end
