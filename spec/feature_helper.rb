require 'rack/test'

require_relative './spec_helper'

module FeatureMixin
  include Rack::Test::Methods

  def app
    App
  end

  # can test json apis like so: `send_json(:post, '/my-url/go', {some: 'data'})`
  # takes care of the boiler plate gunk
  def send_json(method, url, data)
    send(method, url, data.to_json, { "CONTENT_TYPE" => "application/json" })
  end

  OmniAuth.config.test_mode = true
end

RSpec.configure do |config|
  config.include FeatureMixin
  config.before do
    mock_github
  end
end

