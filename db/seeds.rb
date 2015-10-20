require 'bundler/setup'
require 'chronic'
require_relative './../models/auction'
require_relative './../models/user'
require_relative './../models/bid'


auction = Auction.new({
  issue_url: 'https://github.com/18F/mpt3500/issues/10',
  start_price: 3500.0,
  start_datetime: Chronic.parse("October 13 2015 at 2:15 PM"),
  end_datetime: Chronic.parse("October 14 2015 at 3:00 PM"),
  title: 'Build a Placeholder for MPT 3500',
  description: 'This auction is a placeholder for MPT 3500. The MPT 3500 team needs to build the following ...',
  github_repo: 'https://github.com/18F/mpt3500',
  published: 0
})
auction.save

# github_id can be discovered using the github api:
#
bidder = User.new({
  github_id: '86790',
  duns_id: 'DUNS1234',
  sam_id: 'SAM1234'
})
bidder.save

bid = Bid.new({
  auction_id: auction.id,
  bidder_id: bidder.id,
  amount: 3450.0
})
bid.save
