require "clockwork"
require_relative "boot"
require_relative "environment"

module Clockwork
  every(1.day, "losing_bidder_emails.send", at: "03:00", tz: "UTC") do
    puts "Sending losing bidder emails"
    AuctionsCLosedYesterdayFinder.new.perform do |auction|
      LosingBidderEmailSender.new(auction).delay.perform
    end
  end
end
