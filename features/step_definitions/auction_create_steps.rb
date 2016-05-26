Given(/^there is an? (.+) auction$/) do |label|
  @auction = case label
             when 'unpublished'
               FactoryGirl.create(:auction, :unpublished)
             when 'future'
               FactoryGirl.create(:auction, :future)
             when 'closed'
               FactoryGirl.create(:auction, :closed, :with_bidders)
             when 'closed bidless'
               FactoryGirl.create(:auction, :closed)
             when 'expiring'
               FactoryGirl.create(:auction, :expiring, :with_bidders)
             when 'open bidless'
               FactoryGirl.create(:auction)
             when 'open'
               FactoryGirl.create(:auction, :with_bidders)
             when 'single-bid'
               FactoryGirl.create(:auction, :running, :single_bid)
             when 'closed single-bid'
               FactoryGirl.create(:auction, :closed, :with_bidders, :single_bid)
             when 'needs evaluation'
               FactoryGirl.create(:auction, :with_bidders, :evaluation_needed)
             when 'within simplified acquisition threshold'
               FactoryGirl.create(:auction, :between_micropurchase_and_sat_threshold, :available)
             when 'below the micropurchase threshold'
               FactoryGirl.create(:auction, :below_micropurchase_threshold, :available)
             else
               fail "Unrecognized auction type: #{label}"
             end
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
