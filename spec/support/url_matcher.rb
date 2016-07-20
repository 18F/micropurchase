RSpec::Matchers.define :be_url do
  match do |actual|
    URI.parse(actual)
  end
end
