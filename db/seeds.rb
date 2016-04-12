# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

FactoryGirl.create(:auction, :multi_bid, :with_bidders)
FactoryGirl.create(:auction, :multi_bid, :expiring, :with_bidders)
FactoryGirl.create(:auction, :multi_bid, :future)
FactoryGirl.create(:auction, :multi_bid, :closed, :with_bidders)
FactoryGirl.create(:auction, :single_bid, :with_bidders)
FactoryGirl.create(:auction, :single_bid, :expiring, :with_bidders)
FactoryGirl.create(:auction, :single_bid, :future)
FactoryGirl.create(:auction, :single_bid, :closed, :with_bidders)
FactoryGirl.create(:auction, :complete_and_successful)
FactoryGirl.create(:auction, :payment_pending)
FactoryGirl.create(:auction, :payment_needed)
FactoryGirl.create(:auction, :evaluation_needed)
FactoryGirl.create(:auction, :delivery_past_due)
FactoryGirl.create(:auction, :unpublished)
