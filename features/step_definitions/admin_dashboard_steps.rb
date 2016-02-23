Given(/^there are complete and successful auctions$/) do
  @complete_and_successful = Array.new(5) do
    FactoryGirl.create(:auction, :complete_and_successful)
  end
end

When(/^I visit the admin action items page$/) do
  visit admin_action_items_path
end

When(/^I visit the preview page for the unpublished auction$/) do
  visit admin_preview_auction_path(@unpublished_auction) 
end

Then(/^I should see a preview of the auction$/) do
  expect(page).to have_text(@unpublished_auction.description)
end

Then(/^I expect to see the name of each dashboard auction$/) do
  @complete_and_successful.each do |auction|
    expect(page).to have_text(auction.title)
  end
end
