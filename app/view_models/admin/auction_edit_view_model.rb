class Admin::AuctionEditViewModel < SimpleDelegator
  def hour_default(field)
    model.send("#{field}_at").strftime("%l").strip
  end

  def minute_default(field)
    model.send("#{field}_at").strftime("%M").strip
  end

  def meridien_default(field)
    model.send("#{field}_at").strftime("%p")
  end

  def date_default(field)
    model.send("#{field}_at").to_date
  end

  private

  def model
    __getobj__
  end
end
