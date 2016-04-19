ENV['RACK_ENV'] = 'test'
require 'simplecov'
require 'webmock/rspec'
SimpleCov.start

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.order = :random
end

WebMock.disable_net_connect!(allow_localhost: true)
