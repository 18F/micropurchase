When(/^I click on the link to the bids$/) do
  bid = WinningBid.new(@auction).find
  bid_amount = Currency.new(bid.amount).to_s
  click_on(bid_amount)
end

When(/^I click on the "?([^"]+)"? button$/) do |button|
  first(:link_or_button, button).click
end

When(/^I click on the "([^"]+)" link$/) do |label|
  first(:link, label).click
end

When(/^I click on the auction's title$/) do
  click_on(@auction.title)
end

Then(/^I should see an? "([^"]+)" button$/) do |button|
  expect(page).to have_selector(:link_or_button, button)
end

Then(/^I should not see an? "([^"]+)" button$/) do |button|
  expect(page).to_not have_selector(:link_or_button, button)
end
