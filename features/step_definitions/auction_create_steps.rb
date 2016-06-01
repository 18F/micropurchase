Given(/^there is an? (.+) auction$/) do |label|
  @auction = AuctionFactoryFactory.new(label).create
end

Given(/^there is an auction that (.+)$/) do |label|
  @auction = AuctionFactoryFactory.new(label).create
end

Given(/^there is an auction where (.+)$/) do |label|
  @auction = AuctionFactoryFactory.new(label).create
end

Given(/^there is an auction with a starting price between the micropurchase threshold and simplified acquisition threshold$/) do
  @auction = FactoryGirl.create(:auction, :between_micropurchase_and_sat_threshold, :available)
end

Given(/^there are many different auctions$/) do
  FactoryGirl.create(:auction, :closed, title: Faker::Commerce.product_name)
  FactoryGirl.create(:auction, :running, title: Faker::Commerce.product_name)
  FactoryGirl.create(:auction, :future)
end

Given(/^there is also an unpublished auction$/) do
  @unpublished_auction = FactoryGirl.create(:auction, published: false)
end

Given(/^there are complete and successful auctions$/) do
  @complete_and_successful = FactoryGirl.create_list(:auction, 2, :complete_and_successful)
end
