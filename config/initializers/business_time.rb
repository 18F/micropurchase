Holidays.between(Date.today, 5.years.from_now, :us, :observed).map{
  |holiday| BusinessTime::Config.holidays << holiday[:date]
}
