RSpec::Matchers.define :be_iso8601 do
  def to_iso8601(string)
    # JSON iso has 3 digits of milliseconds sometimes, but don't include if 000
    DateTime.parse(string).iso8601(3).gsub('.000+', '+')
  end

  match do |actual|
    actual == to_iso8601(actual) # DateTime.parse(actual).iso8601
  end
  failure_message do |actual|
    "expected that #{actual} would be a valid iso8601 date (#{to_iso8601(actual)})"
  end
end
