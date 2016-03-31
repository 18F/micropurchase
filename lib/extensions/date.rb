# Blindly calculates end of workday using BusinessTime settings.
# Does not consider weekends or holidays.
class Date
  def end_of_workday
    cob = Time.parse(BusinessTime::Config.end_of_workday)
    Time.mktime(self.year, self.month, self.day, cob.hour, cob.min, cob.sec)
  end
end
