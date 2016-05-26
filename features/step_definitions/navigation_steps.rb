When(/^I refresh the page$/) do
  visit page.current_path
end

When(/^I visit the home page$/) do
  visit "/"
end

When(/^I visit my bids page$/) do
  visit my_bids_path
end

When(/^I visit my profile page$/) do
  @user = User.find_by(github_id: @github_id)
  visit users_edit_path
end

When(/^I visit the auction page$/) do
  visit auction_path(@auction)
end

When(/^I visit the unpublished auction$/) do
  visit auction_path(@unpublished_auction)
end

When(/^I visit the auction bids page$/) do
  visit(auction_bids_path(@auction.id))
end

When(/^I visit the auctions admin page$/) do
  visit admin_auctions_path
end

When(/^I visit the admin auction page for that auction$/) do
  visit admin_auction_path(@auction)
end

When(/^I visit the admin edit page for that auction$/) do
  visit edit_admin_auction_path(@auction)
end

When(/^I visit the admin action items page$/) do
  visit admin_action_items_path
end

When(/^I visit the admin drafts page$/) do
  visit admin_drafts_path
end

When(/^I visit the preview page for the unpublished auction$/) do
  visit admin_preview_auction_path(@unpublished_auction)
end

When(/^I visit the admin users page$/) do
  visit admin_users_path
end

When(/^I visit the previous winners page$/) do
  visit "/auctions/winners/"
end

Then(/^I should be on the home page$/) do
  expect(page.current_path).to eq("/")
end

Then(/^I should be on the auction page$/) do
  expect(page.current_path).to eq(auction_path(@auction))
end

Then(/^I should be on my profile page$/) do
  expect(page.current_path).to eq(users_edit_path)
end

Then(/^I should be on the new bid page$/) do
  expect(page.current_path).to eq(new_auction_bid_path(@auction))
end

Then(/^I should be on the bid confirmation page$/) do
  expect(page.current_path).to eq(confirm_auction_bids_path(@auction))
end
