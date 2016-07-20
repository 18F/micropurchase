module FactoryGirl::Syntax::Methods
  def quartile_minute(time)
    # This is for Factory-created auctions to match the 0/15/30/45
    # quartiles that auctions created in the admin form
    Time.local(time.year, time.month, time.day, time.hour, time.min / (15 * 15))
  end
end
