Given(/^there is an unpublished auction$/) do
  @auction = FactoryGirl.create(:auction, :unpublished)
end

Given(/^there is a future auction$/) do
  @auction = FactoryGirl.create(:auction, :future)
end

Given(/^there is a closed auction$/) do
  @auction = FactoryGirl.create(:auction, :closed, :with_bidders)
end

Given(/^I am going to win an auction$/) do
  @auction = FactoryGirl.build(:auction, :available, :with_bidders)
  Timecop.freeze(@auction.ended_at - 15.minutes) do
    bid = @auction.bids.sort_by(&:amount).first
    bid.update(bidder: @user)
    SaveAuction.new(@auction).perform
  end
end

Given(/^I won an auction that was accepted$/) do
  @auction = FactoryGirl.build(:auction, :closed, :accepted, :with_bidders)
  bid = @auction.bids.sort_by(&:amount).first
  bid.update(bidder: @user)
end

Given(/^I am going to lose an auction$/) do
  @auction = FactoryGirl.build(:auction, :available, :with_bidders)
  Timecop.freeze(@auction.ended_at - 15.minutes) do
    bid = @auction.bids.sort_by(&:amount).last
    bid.update(bidder: @user)
    SaveAuction.new(@auction).perform
  end
end

When(/^the auction ends$/) do
  Timecop.return
  Timecop.travel(@auction.ended_at + 5.minutes)
  Delayed::Worker.new.work_off
end

When(/^the auction is paid$/) do
  @auction.update(paid_at: Time.current)
end

When(/^the auction is accepted$/) do
  @auction.update(accepted_at: Time.current)
end

When(/^the auction was marked as paid in C2$/) do
  @auction.update(c2_status: :c2_paid)
end

Given(/^the vendor confirmed payment$/) do
  @auction.update(c2_status: :payment_confirmed)
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

Given(/^there is an open auction with some skills$/) do
  @auction = FactoryGirl.create(:auction)
  skills = FactoryGirl.create_list(:skill, 2)
  @auction.skills << skills
end

Given(/^there is a budget approved auction$/) do
  @auction = FactoryGirl.create(:auction, :c2_approved, :with_bidders)
end

Given(/^there is a sealed-bid auction$/) do
  @auction = FactoryGirl.create(:auction, :available, :sealed_bid)
end

Given(/^there is a sealed-bid auction with bids$/) do
  @auction = FactoryGirl.create(:auction, :available, :sealed_bid, :with_bidders)
end

Given(/^there is a closed sealed-bid auction$/) do
  @auction = FactoryGirl.create(:auction, :closed, :with_bidders, :sealed_bid)
end

Given(/^there is an auction that needs evaluation$/) do
  @auction = FactoryGirl.create(:auction, :with_bidders, :evaluation_needed, :c2_approved)
end

Given(/^there is an auction within the simplified acquisition threshold$/) do
  @auction = FactoryGirl.create(:auction, :between_micropurchase_and_sat_threshold, :available)
end

Given(/^there is an auction below the micropurchase threshold$/) do
  @auction = FactoryGirl.create(:auction, :below_micropurchase_threshold, :available)
end

Given(/^there is an auction with a starting price between the micropurchase threshold and simplified acquisition threshold$/) do
  @auction = FactoryGirl.create(
    :auction,
    :between_micropurchase_and_sat_threshold,
    :available
  )
end

Given(/^there are many different auctions$/) do
  FactoryGirl.create(:auction, :closed, title: Faker::Commerce.product_name)
  FactoryGirl.create(:auction, :available, title: Faker::Commerce.product_name)
  FactoryGirl.create(:auction, :future)
end

Given(/^there is also an unpublished auction$/) do
  @unpublished_auction = FactoryGirl.create(:auction, published: false)
end

Given(/^there is an auction pending acceptance$/) do
  @auction = FactoryGirl.create(:auction, :with_bidders, :pending_acceptance)
end

Given(/^there is a complete and successful auction$/) do
  @auction = FactoryGirl.create(:auction, :complete_and_successful)
end

Given(/^there is a rejected auction$/) do
  @auction = FactoryGirl.create(:auction, :closed, :with_bidders, :delivered, :rejected)
end

Given(/^there is a rejected auction with no bids$/) do
  @auction = FactoryGirl.create(:auction, :closed, :rejected)
end

Given(/^there is an auction where the winning vendor is not eligible to be paid$/) do
  @auction = FactoryGirl.create(
    :auction,
    :delivered,
    :pending_acceptance,
    :between_micropurchase_and_sat_threshold,
    :winning_vendor_is_non_small_business
  )
end

Given(/^there is a paid auction$/) do
  @auction = FactoryGirl.create(:auction, :with_bidders, :closed, :accepted, :paid)
end

Given(/^the auction is for the default purchase card$/) do
  @auction.update(purchase_card: :default)
end

Given(/^the auction is for a different purchase card$/) do
  @auction.update(purchase_card: :other)
end

Given(/^the c2 proposal for the auction is approved$/) do
  @auction.update(c2_status: :approved)
end

Given(/^the c2 proposal for the auction is not approved$/) do
  @auction.update(c2_status: :not_requested)
end

Given(/^the auction does not have a c2 proposal url$/) do
  @auction.update(c2_proposal_url: nil)
end

Given(/^the auction has a c2 proposal url$/) do
  @auction.update!(c2_proposal_url: 'https://c2-dev.18f.gov/proposals/123')
end

Given(/^there is an auction with an associated customer$/) do
  @customer = FactoryGirl.create(:customer)
  @auction = FactoryGirl.create(:auction, customer: @customer)
end

Given(/^there is an auction where the winning vendor is missing a payment method$/) do
  @auction = FactoryGirl.create(:auction, :with_bidders, :evaluation_needed)
  @winning_bidder = WinningBid.new(@auction).find.bidder
  @winning_bidder.update(payment_url: '')
end

Given(/^there is an accepted auction where the winning vendor is missing a payment method$/) do
  @auction = FactoryGirl.create(
    :auction,
    :with_bidders,
    :published,
    status: :accepted,
    accepted_at: nil,
    c2_proposal_url: 'https://c2-dev.18f.gov/proposals/2486'
  )
  @winning_bidder = WinningBid.new(@auction).find.bidder
  @winning_bidder.update(payment_url: '')
end

Given(/^there is an accepted auction$/) do
  @auction = FactoryGirl.create(:auction, :accepted, :with_bidders)
end

When(/^there is another accepted auction$/) do
  FactoryGirl.create(:auction, :accepted, :with_bidders)
end

When(/^there is each type of auction that needs attention$/) do
  # And there are auctions that are either in draft state, pending delivery, needs acceptance, or needs payment
  @needs_attention = []
  @needs_attention << FactoryGirl.create(:auction, :unpublished)
  @needs_attention << FactoryGirl.create(:auction, :payment_needed)
  @needs_attention << FactoryGirl.create(:auction, :pending_acceptance)
  @needs_attention << FactoryGirl.create(:auction, :closed)
end
