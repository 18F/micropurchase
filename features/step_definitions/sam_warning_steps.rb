Then(/^I should not see an alert warning me about my SAM registration$/) do
  expect(page).not_to have_selector(".auction-alert")
end

Then(/^I should see an alert warning me that my SAM registration is not complete$/) do
  expect(page).to have_selector(".auction-alert")
end

When(/^I collapse the alert warning me about my SAM registrtation$/) do
  click_on "collapse"
end

Then(/^I will not see the alert$/) do
  expect(page).not_to have_content("Your DUNS is not registered with SAM*")
end

Then(/^I will see an link to expand the alert$/) do
  expect(page).to have_content("expand")
end
