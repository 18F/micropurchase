class Admin::EditAuctionViewModel
  attr_reader :auction

  def initialize(auction)
    @auction = auction
  end

  def record
    auction
  end

  def new_record?
    false
  end

  def hour_default(field)
    dc_time(field).strftime("%l").strip
  end

  def minute_default(field)
    dc_time(field).strftime("%M").strip
  end

  def meridiem_default(field)
    dc_time(field).strftime("%p")
  end

  def date_default(field)
    dc_time(field).to_date
  end

  private

  def dc_time(field)
    DcTimePresenter.convert(auction.send("#{field}_at"))
  end

end
