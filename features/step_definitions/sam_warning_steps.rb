Then(/^I should not see a warning about my SAM registration$/) do
  expect(page).not_to have_selector(".auction-alert")
end

Then(/^I should see a warning that my SAM registration is not complete$/) do
  expect(page).to have_selector(".auction-alert")
  expect(page).to have_content('Your DUNS is not registered with SAM')

  expect(page).to have_link('SAM.gov', href: 'https://www.sam.gov/')
  expect(page).to have_link('the SAM.gov status checker', href: 'https://www.sam.gov/sam/helpPage/SAM_Reg_Status_Help_Page.html')
  expect(page).to have_link('entered your DUNS number into your profile', href: edit_user_path(@user))
end

When(/^I collapse the warning about my SAM registration$/) do
  click_on "collapse"
end

Then(/^I will not see the warning$/) do
  expect(page).not_to have_content("Your DUNS is not registered with SAM*")
  expect(page).not_to have_content("collapse")
end

Then(/^I will see a link to expand the warning$/) do
  expect(page).to have_content("expand")
  expect(page).not_to have_content("collapse")
end

Then(/^I will see that the warning is still collapsed$/) do
  step "I will see a link to expand the warning"
end

When(/^I click to expand the warning$/) do
  click_on "expand"
end
