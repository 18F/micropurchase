When(/^I click on the "?([^"]+)"? button$/) do |button|
  click_on(button)
end

When(/^I click on the "?([^"]+)"? link$/) do |label|
  click_on(label)
end

When(/^I click on the auction title$/) do
  click_on(@auction.title)
end

Then(/^I expect to see an? (.+) label$/) do |label|
  within(:css, 'div.issue-list-item') do
    within(:css, 'span.usa-label-big') do
      expect(page).to have_content(label)
    end
  end
end

Then(/^I expect to see an? "?([^"]+)"? button$/) do |button|
  expect(page).to have_selector(:link_or_button, button)
end

Then(/^I expect to not see an? "?([^"]+)"? button$/) do |button|
  expect(page).to_not have_selector(:link_or_button, button)
end

When(/^I visit my bids page$/) do
  visit my_bids_path
end

Then(/^I expect to be on the home page$/) do
  expect(page.current_path).to eq("/")
end

Then(/^I expect to be on the auction page$/) do
  expect(page.current_path).to eq(auction_path(@auction))
end

Then(/^I expect to be on the profile edit page$/) do
  expect(page.current_path).to eq(edit_user_path(@user))
end
