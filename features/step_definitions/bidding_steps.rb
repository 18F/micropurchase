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
  winning_bid_amount = Currency.new(WinningBid.new(@auction).find.amount).to_s
  expect(page).to have_content("Winning bid: #{winning_bid_amount}")
  expect(page).not_to have_content("Current bid:")
end

Then(/^I should see the auction had a winning bid with name$/) do
  winning_bid = WinningBid.new(@auction).find
  winning_bidder = winning_bid.bidder
  winning_bid_amount = Currency.new(winning_bid.amount).to_s
  expect(page).to have_content(
    "Winning bid (#{winning_bidder.name}): #{winning_bid_amount}"
  )
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
  expect(page).not_to have_content("Current bid:")
end

When(/^the winning bidder has a valid DUNS number$/) do
  winning_bid = RulesFactory.new(@auction).create.winning_bid
  winning_bid.bidder.update(duns_number: FakeSamApi::VALID_DUNS)
end

Then(/^I should see the winning bid for the auction$/) do
  bid = WinningBid.new(@auction).find
  bid_amount = Currency.new(bid.amount).to_s
  expect(page).to have_text(bid_amount)
end

When(/^I submit a bid for \$(.+)$/) do |amount|
  fill_in("Your bid", with: amount)
  step('I click on the "Place bid" button')
end

Then(/^I should see the maximum bid amount in the bidding form$/) do
  within(".auction-bid") do
    expect(page).to have_content(
      "Maximum bid: #{Currency.new(RulesFactory.new(@auction).create.max_allowed_bid).to_s}"
    )
  end
end

Then(/^I should see I have the winning bid$/) do
  expect(page).to have_content("You currently have the winning bid.")
end

Then(/^I should see I do not have the winning bid$/) do
  expect(page).not_to have_content("You currently have the winning bid.")
end

Then(/^I should see the bid form$/) do
  within('.auction-show') do
    expect(page).to have_selector(:css, '.auction-bid form')
  end
end

Then(/^I should not see the bid form$/) do
  within('.auction-show') do
    expect(page).not_to have_selector(:css, '.auction-bid form')
  end
end
