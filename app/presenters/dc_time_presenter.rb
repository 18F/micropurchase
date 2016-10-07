class DcTimePresenter
  include ActionView::Helpers::TextHelper

  NULL = "&nbsp;".html_safe.freeze
  FORMAT = "%B %d, %Y %r".freeze
  TIME_ZONE_NAME = 'Eastern Time (US & Canada)'.freeze

  attr_reader :time

  def initialize(time)
    @time = time
  end

  def self.convert(time)
    new(time).convert
  end

  def self.parse(time)
    time_zone.parse(time)
  end

  def self.convert_and_format(time, format = FORMAT, timezone_label: true)
    new(time).convert_and_format(format, timezone_label: timezone_label)
  end

  def self.format(time, format = FORMAT)
    new(time).format(format)
  end

  def self.time_zone
    ActiveSupport::TimeZone[TIME_ZONE_NAME]
  end

  def convert
    return unless time
    time.in_time_zone(time_zone)
  end

  def format(format)
    "#{time.strftime(format)} #{timezone_string}"
  end

  def convert_and_format(format = FORMAT, timezone_label: true)
    if time
      str = convert.strftime(format)
      str += " #{timezone_string}" if timezone_label
      str
    else
      NULL
    end
  end

  def relative_time
    time_diff = (time - Time.now).to_i
    abs_time_diff = time_diff.abs

    if abs_time_diff < 24.hours
      relative_time = if abs_time_diff > 3600
                        pluralize(abs_time_diff / 3600, "hour")
                      else
                        pluralize(abs_time_diff / 60, "minute")
                      end

      if time_diff > 0
        "in #{relative_time}"
      else
        "#{relative_time} ago"
      end
    else
      date = convert_and_format('%b %-d, %Y', timezone_label: false)
      time = convert_and_format('%-l:%M %p')
      "on #{date} at #{time}"
    end
  end

  def time_zone
    self.class.time_zone
  end

  def timezone_string
    convert.zone
  end
end
