Given(/^I am a user with a verified SAM account$/) do
  @user = FactoryGirl.create(:user, sam_status: :sam_accepted, github_id: '123451')
  @github_id = @user.github_id
  mock_sign_in(@user.github_id, @user.name)
end

Given(/^I am a user without a verified SAM account$/) do
  @user = FactoryGirl.create(:user, sam_status: :sam_pending, github_id: '123451')
  @github_id = @user.github_id
  mock_sign_in(@user.github_id, @user.name)
end

Given(/^I am a user without a DUNS number$/) do
  @user = FactoryGirl.create(:user, github_id: '123451', duns_number: nil)
  @github_id = @user.github_id
  mock_sign_in(@user.github_id, @user.name)
end

Given(/^I am an administrator$/) do
  @user = FactoryGirl.create(:admin_user)
  @github_id = @user.github_id
  mock_sign_in(@user.github_id, @user.name)
end

Given(/^I am a contracting officer$/) do
  @user = FactoryGirl.create(:contracting_officer)
  @github_id = @user.github_id
  mock_sign_in(@user.github_id, @user.name)
end

When(/^I visit the home page$/) do
  visit "/"
end

When(/^I sign in$/) do
  step "I visit the home page"
  click_on "registered bidder"
  click_on "Authorize with GitHub"
end

Given(/^I am signed in$/) do
  step("I sign in")
end

Given(/^I am an authenticated vendor$/) do
  step("I am a user with a verified SAM account")
  step("I sign in")
end

When(/^I sign in and verify my account information/) do
  step "I sign in"
  step "I visit my profile page"
  click_on "Submit"
end
