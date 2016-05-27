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
    if field_value(field).present?
      dc_time(field).strftime("%l").strip
    else
      "1"
    end
  end

  def minute_default(field)
    if field_value(field).present?
      dc_time(field).strftime("%M").strip
    else
      "00"
    end
  end

  def meridiem_default(field)
    if field_value(field).present?
      dc_time(field).strftime("%p")
    else
      "PM"
    end
  end

  def date_default(field)
    if field_value(field).present?
      dc_time(field).to_date
    else
      DcTimePresenter.convert(Date.today).to_date
    end
  end

  private

  def dc_time(field)
    DcTimePresenter.convert(auction.send("#{field}_at"))
  end

  def field_value(field)
    auction.send("#{field}_at")
  end
end
