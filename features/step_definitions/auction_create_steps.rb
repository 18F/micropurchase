Given(/^there is an unpublished auction$/) do
  @auction = FactoryGirl.create(:auction, :unpublished)
end

Given(/^there is a future auction$/) do
  @auction = FactoryGirl.create(:auction, :future)
end

Given(/^there is a closed auction$/) do
  @auction = FactoryGirl.create(:auction, :closed, :with_bidders)
end

Given(/^there is a closed bidless auction$/) do
  @auction = FactoryGirl.create(:auction, :closed)
end

Given(/^there is an expiring auction$/) do
  @auction = FactoryGirl.create(:auction, :expiring, :with_bidders)
end

Given(/^there is an open bidless auction$/) do
  @auction = FactoryGirl.create(:auction)
end

Given(/^there is an open auction$/) do
  @auction = FactoryGirl.create(:auction, :with_bidders)
end

Given(/^there is a single-bid auction$/) do
  @auction = FactoryGirl.create(:auction, :running, :sealed_bid)
end

Given(/^there is a closed single-bid auction$/) do
  @auction = FactoryGirl.create(:auction, :closed, :with_bidders, :sealed_bid)
end

Given(/^there is an auction that needs evaluation$/) do
  @auction = FactoryGirl.create(:auction, :with_bidders, :evaluation_needed)
end

Given(/^there is an auction within the simplified acquisition threshold$/) do
  @auction = FactoryGirl.create(:auction, :between_micropurchase_and_sat_threshold, :available)
end

Given(/^there is an auction below the micropurchase threshold$/) do
  @auction = FactoryGirl.create(:auction, :below_micropurchase_threshold, :available)
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

Given(/^there is an auction where the winning vendor is not eligible to be paid$/) do
  @auction = FactoryGirl.create(
    :auction,
    :between_micropurchase_and_sat_threshold,
    :winning_vendor_is_non_small_business,
    :evaluation_needed
  )
end

Given(/^there is a paid auction$/) do
  @auction = FactoryGirl.create(:auction, :closed, :paid)
end
