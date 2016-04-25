RSpec::Matchers.define :be_url do |expected|
  match do |actual|
    URI.parse(actual) rescue false
  end
end
