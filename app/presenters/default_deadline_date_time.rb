class DefaultDeadlineDateTime
  attr_reader :dc_time

  def initialize(start_time:, day_offset:)
    @dc_time = day_offset.business_days.after(DcTimePresenter.new(start_time).convert)
  end
end
