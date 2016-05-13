# FIXME: Assign to variable based on type and use name as selector (rather than overwriting @auction)
Given(/^there is an? (.+) auction$/) do |label|
  @auction = case label
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
             else
               fail "Unrecognized auction type: #{label}"
             end
end

Given(/^there are many different auctions$/) do
  FactoryGirl.create(:auction, :closed, title: Faker::Commerce.product_name)
  FactoryGirl.create(:auction, :running, title: Faker::Commerce.product_name)
  FactoryGirl.create(:auction, :future)
end

Given(/^there is also an unpublished auction$/) do
  @unpublished_auction = FactoryGirl.create(:auction, published: false)
end

When(/^I visit the auction page$/) do
  visit "/auctions/#{@auction.id}"
end

When(/^I visit the unpublished auction$/) do
  visit "/auctions/#{@unpublished_auction.id}"
end

Then(/^I should see the winning bid for the auction$/) do
  auction = AuctionPresenter.new(@auction)
  lowest_bid_amount = ApplicationController.helpers.number_to_currency(
    auction.lowest_bid.amount
  )

  expect(page).to have_text(lowest_bid_amount)
end

Then(/^I should see the auction's (.+)$/) do |field|
  if field == 'deadline'
    expect(page).to have_text(
      DcTimePresenter
        .convert(@auction.end_datetime)
        .beginning_of_day
        .strftime(DcTimePresenter::FORMAT))
  else
    expect(page).to have_text(@auction.send(field))
  end
end

Then(/^I should see when bidding starts and ends in ET$/) do
  expect(page).to have_text(
    DcTimePresenter.convert_and_format(@auction.start_datetime))

  expect(page).to have_text(
    DcTimePresenter.convert_and_format(@auction.end_datetime))
end

Then(/^I should see the delivery deadline in ET$/) do
  expect(page).to have_text(
    DcTimePresenter.convert_and_format(@auction.delivery_deadline))
end

Then(/^I should see the start price for the auction is \$(\d+)$/) do |price|
  expect(page).to have_field('auction_start_price', with: price)
end

Then(/^I should see the number of bid for the auction$/) do
  number_of_bids = "#{@auction.bids.length} bids"
  expect(page).to have_content(number_of_bids)
end

Then(/^I should not see the number of bid for the auction$/) do
  number_of_bids = "#{@auction.bids.length} bids"
  expect(page).to_not have_content(number_of_bids)
end

When(/^I click on the link to the bids$/) do
  number_of_bids = "#{@auction.bids.length} bids"
  click_on(number_of_bids)
end

Then(/^I should see the bid history$/) do
  h1_text = "Bids for \"#{@auction.title}\""
  expect(page).to have_content(h1_text)
end

Then(/^I should not see the unpublished auction$/) do
  expect(page).to_not have_content(@unpublished_auction.title)
end

Then(/^I should see a routing error$/) do
  expect(response).to raise_error(ActionController::RoutingError)
end

Then(/^I should see a message about no auctions$/) do
  expect(page).to have_content(
    "There are no current open auctions on the site. " \
    "Please check back soon to view micropurchase opportunities."
  )
end

Then(/^I should see a message about no bids$/) do
  expect(page).to have_content("No bids yet.")
end

When(/^I submit a bid for \$(.+)$/) do |amount|
  fill_in("Your bid:", with: amount)
  step('I click on the "Submit" button')
end

Then(/^I should see a current bid amount( of \$([\d\.]+))?$/) do |_, amount|
  expect(page).to have_content(/Current bid: \$[\d,\.]+/)
  expect(page).to have_content(amount) unless amount.nil?
end

Then(/^I should see a winning bid amount( of \$([\d\.]+))?$/) do |_, amount|
  expect(page).to have_content(/Winning bid \([^\)]+\): \$[\d,\.]+/)
  expect(page).to have_content(amount) unless amount.nil?
end

Then(/^I should see a link to the auction issue URL$/) do
  page.find("a[href='#{@auction.issue_url}']")
end

Then(/^I should see a confirmation for \$(.+)$/) do |amount|
  expect(page).to have_content("Confirm your bid: $#{amount}")
end

Then(/^I should see I have the winning bid$/) do
  expect(page).to have_content("You currently have the winning bid.")
  expect(page).to_not have_content("You are currently not the winning bidder.")
end

Then(/^I should see I do not have the winning bid$/) do
  expect(page).not_to have_content("You are currently the winning bidder.")
  expect(page).to have_content("You are currently not the winning bidder.")
end

Then(/^I should see when the auction started$/) do
  expect(page).to have_text(
    DcTimePresenter.convert_and_format(@auction.start_datetime))
end

Then(/^I should see when the auction ends$/) do
  expect(page).to_not have_content("Auction ended at:")
  expect(page).to have_content("Bid deadline: #{DcTimePresenter.convert_and_format(@auction.end_datetime)}")
end

Then(/^I should see when the auction ended$/) do
  expect(page).to_not have_content("Bid deadline:")
  expect(page).to have_text("Auction ended at: #{DcTimePresenter.convert_and_format(@auction.end_datetime)}")
end

Then(/^I should see the delivery deadline$/) do
  expect(page).to have_content("Delivery deadline: #{DcTimePresenter.convert_and_format(@auction.delivery_deadline)}")
end

Then(/^I should see an? (.+) status$/) do |label|
  within(:css, 'div.auction-info') do
    expect(page).to have_content(label)
  end
end
