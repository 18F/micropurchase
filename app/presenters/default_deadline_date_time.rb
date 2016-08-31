# used for computing the default deadline with an offset
class DefaultDeadlineDateTime
  attr_reader :dc_time

  def self.parse(start_time_str, day_offset)
    time = DcTimePresenter.parse(start_time_str)
    new(time, day_offset)
  end

  def initialize(start_time, day_offset)
    @dc_time = day_offset.business_days.after(DcTimePresenter.new(start_time).convert)
  end
end
