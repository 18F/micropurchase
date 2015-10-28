module Presenter
  class DcTime < Struct.new(:time)
    def convert
      return unless time
      time.in_time_zone(ActiveSupport::TimeZone['Eastern Time (US & Canada)'])
    end

    def convert_and_format(format=:long)
      return Bid::Null::NULL unless time
      convert.to_s(format)
    end

    def self.convert(time)
      new(time).convert
    end

    def self.convert_and_format(time, format=:long)
      new(time).convert_and_format(format)
    end
  end
end
