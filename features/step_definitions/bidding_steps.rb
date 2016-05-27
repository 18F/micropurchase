When(/^the auction has a lowest bid amount of (.+)$/) do |amount|
  @auction.lowest_bid.update(amount: amount.to_i)
end

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

When(/^the winning bidder has a valid DUNS number$/) do
  winning_bid = RulesFactory.new(@auction).create.winning_bid
  winning_bid.bidder.update(duns_number: FakeSamApi::VALID_DUNS)
end

Then(/^I should see the winning bid for the auction$/) do
  auction = AuctionPresenter.new(@auction)
  lowest_bid_amount = ApplicationController.helpers.number_to_currency(
    auction.lowest_bid.amount
  )

  expect(page).to have_text(lowest_bid_amount)
end

When(/^I submit a bid for \$(.+)$/) do |amount|
  fill_in("Your bid:", with: amount)
  step('I click on the "Submit" button')
end

Then(/^I should see I have the winning bid$/) do
  expect(page).to have_content("You currently have the winning bid.")
  expect(page).to_not have_content("You are currently not the winning bidder.")
end

Then(/^I should see I do not have the winning bid$/) do
  expect(page).not_to have_content("You are currently the winning bidder.")
  expect(page).to have_content("You are currently not the winning bidder.")
end

Then(/^I should see the bid button$/) do
  within(:css, 'div.auction-info') do
    expect(page).to have_content('BID')
  end
end

Then(/^I should not see the bid button$/) do
  within(:css, 'div.auction-info') do
    expect(page).to_not have_content('BID')
  end
end
