RSpec::Matchers.define :be_iso8601 do |expected|
  def to_iso8601(string)
    DateTime.parse(string).iso8601
  end

  match do |actual|
    actual == to_iso8601(actual) #DateTime.parse(actual).iso8601
  end
  failure_message do |actual|
    "expected that #{actual} would be a valid iso8601 date (#{to_iso8601(actual)})"
  end
end
