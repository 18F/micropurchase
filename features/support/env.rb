require 'simplecov'
require 'cucumber/rails'
require 'database_cleaner'
require 'cucumber/rspec/doubles'
require 'capybara/poltergeist'
require 'webmock/cucumber'

Dir[Rails.root.join("spec/support/*.rb")].each { |file| require file }

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false)
end

Capybara.javascript_driver = :poltergeist

Delayed::Worker.delay_jobs = false

Before('@background_jobs_off') do
  Delayed::Worker.delay_jobs = true
end

After('@background_jobs_off') do
  Delayed::Worker.delay_jobs = false
end

ActionController::Base.allow_rescue = false

begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

Cucumber::Rails::Database.javascript_strategy = :truncation

Before do |scenario|
  WebMock.stub_request(:any, /api.data.gov/).to_rack(FakeSamApi)
  WebMock.stub_request(:any, /cap.18f.gov/).to_rack(FakeC2Api)
  WebMock.stub_request(:any, /c2-dev.18f.gov/).to_rack(FakeC2Api)
end

WebMock.disable_net_connect!(allow_localhost: true, allow: "codeclimate.com")
