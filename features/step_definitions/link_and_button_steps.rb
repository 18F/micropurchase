When(/^I click on the link to the bids$/) do
  number_of_bids = "#{@auction.bids.length} bids"
  click_on(number_of_bids)
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

Then(/^I should see a link to the previous winners archive page$/) do
  expect(page).to have_link('See all previous winners')
end

Then(/^I click on the previous winners link$/) do
  first(:link, 'See all previous winners').click
end
