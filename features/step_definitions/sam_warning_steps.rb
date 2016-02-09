Then(/^I should not see an alert warning me about my SAM registration$/) do
  expect(page).not_to have_selector(".auction-alert")
end

Then(/^I should see an alert warning me that my SAM registration is not complete$/) do
  expect(page).to have_selector(".auction-alert")
end
