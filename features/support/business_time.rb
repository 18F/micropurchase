# Business_time doesn't seem to get along with poltergeist bc threading
# See https://github.com/18F/micropurchase/issues/1318 for details
module BusinessTime
  class Config
    class << self
      def config
        @_config ||= default_config
      end
    end
  end
end

Holidays.between(Date.today, 2.years.from_now, :us, :observed).each do
  |holiday| BusinessTime::Config.holidays << holiday[:date]
end
