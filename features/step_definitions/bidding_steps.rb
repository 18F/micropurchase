When(/^the auction has a lowest bid amount of (.+)$/) do |amount|
  @auction.lowest_bid.update(amount: amount.to_i)
end

When(/^the auction has a start price of (.+)$/) do |amount|
  @auction.update(start_price: amount.to_i)
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

Then(/^I should see that I did not have the winning bid$/) do
  bid = @auction.bids.where(bidder: @user).last
  bid_amount = Currency.new(bid.amount).to_s

  expect(page).to have_content(
    I18n.t(
      'statuses.bid_status_presenter.over.bidder.body',
      bid_amount: bid_amount,
      end_date: end_date
    )
  )
end

Then(/^I should see I am not the winner$/) do
  expect(page).to have_content("You are not the winner")
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
  max_allowed_bid_as_currency = Currency.new(RulesFactory.new(@auction).create.max_allowed_bid)
  within(".usa-alert-info") do
    expect(page).to have_content(
      I18n.t(
        'statuses.bid_status_presenter.available.vendor.eligible.body',
        max_allowed_bid_as_currency: max_allowed_bid_as_currency
      )
    )
  end
end

Then(/^I should see I have the winning bid$/) do
  expect(page).to have_content("You are currently the low bidder")
end

Then(/^I should see I do not have the winning bid$/) do
  expect(page).to have_content("You've been outbid!")
end

Then(/^I should see the bid form$/) do
  within('.auction-show') do
    expect(page).to have_selector(:css, '.auction-detail-panel form')
  end
end

Then(/^I should not see the bid form$/) do
  within('.auction-show') do
    expect(page).not_to have_selector(:css, '.auction-detail-panel form')
  end
end

Then(/^I should see my bid is too high$/) do
  max_allowed_bid = RulesFactory.new(@auction).create.max_allowed_bid

  expect(page).to have_content(
    I18n.t('activerecord.errors.models.bid.amount.greater_than_max',
           max_allowed_bid: max_allowed_bid)

  )
end

def end_date
  DcTimePresenter.convert_and_format(@auction.ended_at)
end
