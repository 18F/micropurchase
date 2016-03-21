When(/^I have placed the lowest bid$/) do
  # sort the bids so that newest is first
  bids = @auction.bids.sort_by(&:created_at).reverse
  b = bids.first
  b.update_attribute(:bidder_id, @user.id)
end

When(/^I have placed a bid$/) do
  step("I have placed the lowest bid")
end

When(/^I have placed a bid that is not the lowest$/) do
  # sort the bids so that newest is first
  bids = @auction.bids.sort_by(&:created_at).reverse
  b = bids[1]
  b.update_attribute(:bidder_id, @user.id)
end

When(/^I have not placed a bid$/) do
  # nothing to do here
end

Then(/^I should see the auction had a winning bid$/) do
  auction = Presenter::Auction.new(@auction)
  expect(page).to have_content("Winning bid (#{auction.current_bidder_name}):")
  expect(page).not_to have_content("Current bid:")
end

Then(/^I should see I am the winner$/) do
  expect(page).to have_css('.usa-alert-success')
  expect(page).to have_content("You are the winner")
end

Then(/^I should see I am not the winner$/) do
  expect(page).to have_css('.usa-alert-error')
  expect(page).to have_content("You are not the winner")
end

Then(/^I should not see a winner alert box$/) do
  expect(page).to_not have_css('.usa-alert-error')
  expect(page).to_not have_content("You are not the winner")
end

Then(/^I should see when the auction ended$/) do
  expect(page).to have_content("Auction ended at:")
  expect(page).not_to have_content("Bid deadline:")
end

Then(/^I should see the auction ended with no bids$/) do
  expect(page).to have_content("This auction ended with no bids.")
  expect(page).to have_content("Current bid:")
end
