require "clockwork"
require_relative "boot"
require_relative "environment"

module Clockwork
  every(1.day, "tock_projects.import", at: "02:00", tz: 'Eastern Time (US & Canada)') do
    puts "Importing Tock projects"
    TockImporter.new.delay.perform
  end

  every(1.day, "c2_payments.check", at: "04:00", tz: 'Eastern Time (US & Canada)') do
    puts "Checking for paid auctions"
    CheckPayment.new.delay.perform
  end

  every(1.hour, "c2_approvals.check") do
    puts "Checking for approved auctions"
    CheckApproval.new.delay.perform
  end
end
