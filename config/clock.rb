require "clockwork"
require_relative "boot"
require_relative "environment"

module Clockwork
  every(1.day, "losing_bidder_emails.send", at: "17:05", tz: 'Eastern Time (US & Canada)') do
    puts "Sending losing bidder emails"
    AuctionQuery.new.closed_yesterday do |auction|
      LosingBidderEmailSender.new(auction).delay.perform
    end
  end

  every(1.day, "winning_bidder_emails.send", at: "17:05", tz: 'Eastern Time (US & Canada)') do
    puts "Sending winning bidder emails"
    AuctionQuery.new.closed_within_last_24_hours do |auction|
      WinningBidderEmailSender.new(auction).delay.perform
    end
  end

  every(1.day, "tock_projects.import", at: "02:00", tz: 'Eastern Time (US & Canada)') do
    puts "Importing Tock projects"
    TockImporter.new.delay.perform
  end

  every(1.day, "tock_projects.import", at: "04:00", tz: 'Eastern Time (US & Canada)') do
    puts "Checking for paid auctions"
    CheckPayment.new.delay.perform
  end
end
