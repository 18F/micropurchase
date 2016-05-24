Then(/^I expect the page to show me the number of regular users$/) do
  expect(page).to have_text("Users (#{@number_of_users}")
end

Then(/^I expect the page to show me the number of admin users$/) do
  expect(page).to have_text("Admins (1)")
end
