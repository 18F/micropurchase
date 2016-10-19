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

module AuctionHelpers
  def end_date
    DcTimePresenter.convert_and_format(@auction.ended_at)
  end

  def start_date
    DcTimePresenter.convert_and_format(@auction.started_at)
  end

  def delivery_due_date
    DcTimePresenter.convert_and_format(@auction.delivery_due_at)
  end

  def accept_date
    DcTimePresenter.convert_and_format(@auction.accepted_at)
  end

  def winning_bid
    WinningBid.new(@auction.reload).find
  end

  def winning_amount
    Currency.new(winning_bid.amount).to_s
  end

  def pay_date
    DcTimePresenter.convert_and_format(@auction.paid_at)
  end

  def winner_url
    Url.new(
      link_text: winner_name,
      path_name: 'admin_user',
      params: { id: winner.id }
    )
  end

  def winner_name
    winner.name || winner.github_login
  end

  def winner
    winning_bid.bidder
  end

  def customer
    @auction.customer
  end

  def customer_url
    Url.new(
      link_text: customer.agency_name,
      path_name: 'admin_customer',
      params: { id: customer.id }
    )
  end
end

World(AuctionHelpers)

Before do
  WebMock.stub_request(:any, /api.data.gov/).to_rack(FakeSamApi)
  WebMock.stub_request(:any, /cap.18f.gov/).to_rack(FakeC2Api)
  WebMock.stub_request(:any, /c2-dev.18f.gov/).to_rack(FakeC2Api)
end

WebMock.disable_net_connect!(allow_localhost: true, allow: "codeclimate.com")
