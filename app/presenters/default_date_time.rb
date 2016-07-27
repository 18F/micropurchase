class DefaultDateTime
  HOUR = "13".freeze
  MINUTE = "00".freeze

  attr_reader :dc_time

  def initialize(time = Time.current)
    @dc_time = DcTimePresenter.new(time).convert
  end

  def convert
    @_converted ||= dc_time.change(hour: HOUR, min: MINUTE, sec: 0)
  end

  def hour
    convert.strftime('%l').strip
  end

  def minute
    convert.strftime('%M').strip
  end

  def meridiem
    convert.strftime('%p').strip
  end
end
