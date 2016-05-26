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
    auction.send("#{field}_at").strftime("%l").strip
  end

  def minute_default(field)
    auction.send("#{field}_at").strftime("%M").strip
  end

  def meridien_default(field)
    auction.send("#{field}_at").strftime("%p")
  end

  def date_default(field)
    auction.send("#{field}_at").to_date
  end
end
