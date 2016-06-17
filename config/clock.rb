require "clockwork"
require_relative "boot"
require_relative "environment"

module Clockwork
  every(1.day, "losing_bidder_emails.send", at: "03:00", tz: "UTC") do
    puts "Sending losing bidder emails"
    AuctionsClosedYesterdayFinder.new.perform do |auction|
      LosingBidderEmailSender.new(auction).delay.perform
    end
  end

  every(1.day, "tock_projects.import", at: "02:00", tz: "UTC") do
    puts "Importing Tock projects"
    TockImporter.new.delay.perform
  end

  every(1.day, "tock_projects.import", at: "04:00", tz: "UTC") do
    puts "Checking for paid auctions"
    CheckPayment.new.delay.perform
  end
end
