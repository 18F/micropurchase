# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

FactoryGirl.create(:auction, :with_bidders)
FactoryGirl.create(:auction, :expiring, :with_bidders)
FactoryGirl.create(:auction, :future, :with_bidders)
FactoryGirl.create(:auction, :closed, :with_bidders)
