class Admin::NewAuctionViewModel
  def new_record
    Auction.new
  end

  def new_record?
    true
  end

  def hour_default(_field)
    "7"
  end

  def minute_default(_field)
    "00"
  end

  def meridien_default(_field)
    "PM"
  end

  def date_default(_field)
    Date.today
  end
end
