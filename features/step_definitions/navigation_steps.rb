When(/^I refresh the page$/) do
  visit page.current_path
end

When(/^I visit the home page$/) do
  visit "/"
end

When(/^I visit my profile page$/) do
  visit profile_path
end

When(/^I visit my bid history page$/) do
  visit bids_placed_path
end

When(/^I visit the auction page$/) do
  visit auction_path(@auction)
end

When(/^I visit the auctions page$/) do
  visit auctions_path
end

When(/^I visit the unpublished auction$/) do
  visit auction_path(@unpublished_auction)
end

When(/^I visit the admin page$/) do
  visit admin_path
end

When(/^I visit the admin sign in page$/) do
  visit admin_sign_in_path
end

When(/^I visit the admin auction page for that auction$/) do
  visit admin_auction_path(@auction)
end

When(/^I visit the admin auction page with the token/) do
  visit auction_path(@auction, token: @auction.token)
end

When(/^I visit the admin form for that auction$/) do
  visit edit_admin_auction_path(@auction)
end

When(/^I visit the admin needs attention auctions page$/) do
  visit admin_auctions_needs_attention_path
end

When(/^I visit the admin admins page$/) do
  visit admin_admins_path
end

When(/^I visit the admin vendors page$/) do
  visit admin_vendors_path
end

When(/^I visit the insights page$/) do
  visit insights_path
end

When(/^I visit the admin customers page$/) do
  visit admin_customers_path
end

When(/^I visit the previous winners page$/) do
  visit winners_path
end

When(/^I visit the skills admin page$/) do
  visit admin_skills_path
end

When(/^I visit the admin closed auctions page$/) do
  visit admin_auctions_closed_path
end

Given(/^I visit the Needs Attention page$/) do
  visit admin_auctions_needs_attention_path
end

Given(/^I visit the new auction receipt page$/) do
  visit new_auction_receipt_path(@auction)
end

Given(/^I visit the auction receipt page$/) do
  visit auction_receipt_path(@auction)
end

Then(/^I should be on the Needs Attention page$/) do
  expect(page.current_path).to eq(admin_auctions_needs_attention_path)
end

Then(/^I should be on the skills admin page$/) do
  expect(page.current_path).to eq(admin_skills_path)
end

Then(/^I should be on the home page$/) do
  expect(page.current_path).to eq("/")
end

Then(/^I should be on the auction page$/) do
  expect(page.current_path).to eq(auction_path(@auction))
end

Then(/^I should be on my profile page$/) do
  expect(page.current_path).to eq(profile_path)
end

Then(/^I should be on the admin auction page for that auction$/) do
  expect(page.current_path).to eq(admin_auction_path(@auction))
end

Then(/^I should be on the admin form for that auction$/) do
  expect(page.current_path).to eq(edit_admin_auction_path(@auction))
end

Then(/^I should be on the new admin customer form/) do
  expect(page.current_path).to eq(new_admin_customer_path)
end

Then(/^I should be on the admin customers page/) do
  expect(page.current_path).to eq(admin_customers_path)
end

Then(/^I should be on my bids page$/) do
  expect(page.current_path).to eq(bids_path)
end

Then(/^I should be on the sign up page$/) do
  expect(page.current_path).to eq(sign_up_path)
end

When(/^I should be on the admin needs attention auctions page$/) do
  expect(page.current_path).to eq admin_auctions_needs_attention_path
end

When(/^I should be on the admin admins page$/) do
  expect(page.current_path).to eq(admin_admins_path)
end

When(/^I should be on the admin vendors page$/) do
  expect(page.current_path).to eq(admin_vendors_path)
end

Then(/^I should be on the auction receipt page$/) do
  expect(page.current_path).to eq(new_auction_receipt_path(@auction))
end

Then(/^I should be on the rules page for reverse auctions$/) do
  expect(page.current_path).to eq('/auctions/rules/reverse')
end

Then(/^I should be on the rules page for sealed-bid auctions$/) do
  expect(page.current_path).to eq('/auctions/rules/sealed-bid')
end

Then(/^I should be on the admin login page$/) do
  expect(page.current_path).to eq(admin_sign_in_path)
end
