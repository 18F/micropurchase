When(/^I visit the admin users page$/) do
  visit admin_users_path
end

When(/^I should see my user info$/) do
  user = Presenter::User.new(@user)

  expect(page).to have_text(user.duns_number)
  expect(page).to have_text(user.email)
  expect(page).to have_text(user.name)
  expect(page).to have_text(user.github_id)
  expect(page).to have_text(user.in_sam?)
end

Given(/^there are users in the system$/) do
  @number_of_users = 11
  @number_of_users.times { FactoryGirl.create(:user) }
end

Then(/^I expect the page to show me the number of regular users$/) do
  expect(page).to have_text("Users (#{@number_of_users}")
end

Then(/^I expect the page to show me the number of admin users$/) do
  expect(page).to have_text("Admins (1)")
end

