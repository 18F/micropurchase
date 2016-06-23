class Admin::NewAuctionViewModel < Admin::BaseViewModel
  def new_record
    Auction.new
  end

  def new_auction_nav_class
    'usa-current'
  end

  def delivery_due_partial
    'admin/auctions/due_in_days'
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

  def billable_to_options
    ClientAccount.all.map(&:to_s)
  end

  private

  def default_date_time
    DefaultDateTime.new
  end
end
