When(/^I click on the "?(.+)"? button$/) do |button|
  click_on(button)
end

When(/^I click on "?(.+)"? link$/) do |label|
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
