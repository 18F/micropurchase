module Presenter
  class DcTime < Struct.new(:time)
    FORMAT = "%B %d, %Y %r".freeze

    def self.convert(time)
      new(time).convert
    end

    def self.convert_and_format(time, format = FORMAT)
      new(time).convert_and_format(format)
    end

    def convert
      if time
        time.in_time_zone(ActiveSupport::TimeZone['Eastern Time (US & Canada)'])
      end
    end

    def convert_and_format(format = FORMAT)
      if time
        convert.strftime(format)
      else
        Presenter::Bid::Null::NULL
      end
    end
  end
end
