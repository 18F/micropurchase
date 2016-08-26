require "clockwork"
require_relative "boot"
require_relative "environment"
require_relative "../lib/server_env"

module Clockwork
  # disabled until https://github.com/18F/micropurchase/issues/951 is fixed
  # every(1.day, "tock_projects.import", at: "02:00", tz: 'Eastern Time (US & Canada)') do
  # puts "Importing Tock projects"
  # TockImporter.new.delay.perform
  # end
  #
  if ServerEnv.first_instance? || Rails.env.development?
    c2_update_interval = ENV.fetch('C2_UPDATE_INTERVAL', '10')

    every(c2_update_interval.to_i.minutes, "c2_payments.check") do
      puts "Checking for paid auctions"
      CheckPayment.new.delay.perform
    end

    every(c2_update_interval.to_i.minutes, "c2_approvals.check") do
      puts "Checking for approved auctions"
      CheckApproval.new.delay.perform
    end

    every(1.day, "insight_metrics.update", at: "02:00", tz: 'Eastern Time (US & Canada)') do
      puts "Updating insight metrics"
      UpdateInsightMetrics.new.delay.perform
    end
  end
end
