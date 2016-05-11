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

When(/^I check the 'Contracting officer' checkbox$/) do
  check('user_contracting_officer')
end

When(/^I submit the changes to the user$/) do
  click_on "Update User"
end

Then(/^I expect there to be a contracting officer in the list of users$/) do
  within(:xpath, "html/body/div/div/div/table[2]/tbody/tr[1]/td[5]") do
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

Given(/^there are various types of users in the system$/) do
  @users = []

  30.times do
    has_duns = rand(4)
    in_sam = has_duns && rand(4)
    small_biz = in_sam && rand(4)

    opts = { }
    opts[:duns_number] = nil unless has_duns
    opts[:sam_status] = :sam_accepted if in_sam
    opts[:small_business] = true if small_biz

    @users << FactoryGirl.create(:user, opts)
  end
end
