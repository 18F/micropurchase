class DefaultDeadlineDateTime
  attr_reader :start_time, :day_offset

  def initialize(start_time:, day_offset:)
    @start_time = start_time
    @day_offset = day_offset
  end

  def dc_time
    day_offset.business_days.after(DcTimePresenter.new(start_time).convert)
  end
end
