Holidays.between(Date.today, 5.years.from_now, :us, :observed).map do
  |holiday| BusinessTime::Config.holidays << holiday[:date]
end
