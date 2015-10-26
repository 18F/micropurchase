module Presenter
  class DcTime < Struct.new(:time)
    def convert
      return unless time
      time.in_time_zone(ActiveSupport::TimeZone['Eastern Time (US & Canada)'])
    end

    def self.convert(time)
      new(time).convert
    end
  end
end
