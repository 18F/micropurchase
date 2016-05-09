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
  b.update(bidder: @user)
end

When(/^I have not placed a bid$/) do
  # nothing to do here
end

Then(/^I should see the auction had a winning bid$/) do
  auction = AuctionViewModel.new(nil, @auction)
  expect(page).to have_content("Winning bid: #{auction.highlighted_bid_amount_as_currency}")
  expect(page).not_to have_content("Current bid:")
end

Then(/^I should see the auction had a winning bid with name$/) do
  auction = AuctionViewModel.new(nil, @auction)
  expect(page)
    .to have_content("Winning bid (#{auction.highlighted_bidder_name}): #{auction.highlighted_bid_amount_as_currency}")
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

Then(/^I should see the auction ended with no bids$/) do
  expect(page).to have_content("This auction ended with no bids.")
  expect(page).to have_content("Current bid:")
end
