# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

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
# bidder = User.new({
#   github_id: '86790',
#   duns_id: 'DUNS1234'
# })
# bidder.save
#
# bid = Bid.new({
#   auction_id: auction.id,
#   bidder_id: bidder.id,
#   amount: 3450.0
# })
# bid.save
