Given(/^there are users in the system$/) do
  @number_of_users = 1
  FactoryGirl.create(:user)
end

When(/^I visit the admin users page$/) do
  visit admin_users_path
end

When(/^I should see my user info$/) do
  user = UserPresenter.new(@user)

  expect(page).to have_text(user.duns_number)
  expect(page).to have_text(user.email)
  expect(page).to have_text(user.name)
  expect(page).to have_text(user.github_id)
  expect(page).to have_text(user.in_sam?)
end

When(/^I click the edit user link next to the first non-admin user$/) do
  within(:xpath, '/html/body/div/div/table[2]') do
    click_on "Edit"
  end
end

When(/^I click the edit user link next to the first admin user$/) do
  within(:xpath, '/html/body/div/div/table[1]') do
    click_on "Edit"
  end
end

When(/^I check the 'Contracting officer' checkbox$/) do
  check('user_contracting_officer')
end

When(/^I submit the changes to the user$/) do
  click_on "Update User"
end

Then(/^I expect there to be a contracting officer in the list of admin users$/) do
  within(:css, "table#table-admins tbody tr td:nth-child(5)") do
    expect(page).to have_content("true")
  end
end

Then(/^I expect the page to show me the number of regular users$/) do
  expect(page).to have_text("Users (#{@number_of_users}")
end

Then(/^I expect the page to show me the number of admin users$/) do
  expect(page).to have_text("Admins (1)")
end

Then(/^I should see a column labeled "([^"]+)"$/) do |text|
  find('th', text: text)
end

Given(/^there is a user in SAM.gov who is not a small business$/) do
  @user = FactoryGirl.create(:user, sam_status: :sam_accepted, small_business: false)
end

Given(/^there is a user in SAM.gov who is a small business$/) do
  @user = FactoryGirl.create(:user, sam_status: :sam_accepted, small_business: true)
end

Given(/^there is a user who is not in SAM.gov$/) do
  @user = FactoryGirl.create(:user, sam_status: :sam_pending)
end

Then(/^I should see "([^"]+)" for the user in the "([^"]+)" column$/) do |value, column|
  user_admin_columns = ['Name', 'Email', 'DUNS Number', 'SAM.gov status',
                        'Small Business?', 'Github ID']

  index = user_admin_columns.index(column)
  fail 'Unrecognized column: #{column}' if index.nil?
  css = "table#table-users tbody tr td:nth-child(#{index+1})"

  within(css) do
    expect(page).to have_content(value)
  end
end
