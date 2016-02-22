# coding: utf-8

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
             else
               fail "Unrecognized auction type: #{label}"
             end
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

Then(/^I expect to see the winning bid for the auction$/) do
  auction = Presenter::Auction.new(@auction)
  current_bid_amount = ApplicationController.helpers.number_to_currency(
    auction.current_bid.amount
  )

  expect(page).to have_text(current_bid_amount)
end

Then(/^I expect to see the auction (.+)$/) do |field|
  if field == 'deadline'
    expect(page).to have_text(
                      Presenter::DcTime.convert(@auction.end_datetime).
                      beginning_of_day.strftime(Presenter::DcTime::FORMAT)
                    )
  else
    expect(page).to have_text(@auction.send(field))
  end
end

Then(/^I expect to see the number of bid for the auction$/) do
  number_of_bids = "#{@auction.bids.length} bids"
  expect(page).to have_content(number_of_bids)
end

When(/^I click on the link to the bids$/) do
  number_of_bids = "#{@auction.bids.length} bids"
  click_on(number_of_bids)
end

Then(/^I expect to see the bid history$/) do
  h1_text = "Bids for \"#{@auction.title}\""
  expect(page).to have_content(h1_text)

  # FIXME: more
end

Then(/^I expect to not see the unpublished auction$/) do
  expect(page).to_not have_content(@unpublished_auction.title)
end

Then(/^I should see a routing error$/) do
  expect(response).to raise_error(ActionController::RoutingError)
end

Then(/^I expect to see a message about no auctions$/) do
  expect(page).to have_content("There are no current open auctions on the site. " \
                               "Please check back soon to view micropurchase opportunities.")
end

Then (/^I expect to see a message about no bids$/) do
  expect(page).to have_content("No bids yet.")
end

When(/^I submit a bid for \$(.+)$/) do |amount|
  fill_in("bid_amount", with: amount)
  click_on("Submit")
end

Then(/^I expect to see a current bid amount( of \$([\d\.]+))?$/) do |_, amount|
  expect(page).to have_content("Current bid:")
  expect(page).to have_content(amount) unless amount.nil?
end

Then(/^I expect to see a link to the auction issue URL$/) do
  page.find("a[href='#{@auction.issue_url}']")
end

Then(/^I expect to see a confirmation for \$(.+)$/) do |amount|
  expect(page).to have_content("Confirm your bid: $#{amount}")
end

Then(/^I expect to see I have the winning bid$/) do
  expect(page).to have_content("You currently have the winning bid.")
  expect(page).to_not have_content("You are currently not the winning bidder.")
end

Then(/^I expect to see I do not have the winning bid$/) do
  expect(page).not_to have_content("You are currently the winning bidder.")
  expect(page).to have_content("You are currently not the winning bidder.")
end  

# Fix me (look for specific date in there)
Then(/^I expect to see when the auction started$/) do
  expect(page).to_not have_content("Auction ended at:")
end

Then(/^I expect to see when the auction ends$/) do
  expect(page).to_not have_content("Auction ended at:")
  expect(page).to have_content("Bid deadline:")
end

Then(/^I expect to see an? (.+) status$/) do |label|
  within(:css, 'div.auction-info') do
    expect(page).to have_content(label)
  end
end
