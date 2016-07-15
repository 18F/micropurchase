When(/^I sign in$/) do
  step "I visit the home page"
  click_on "Sign in"
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
  click_on "Update"
end

When(/^I am the winning bidder$/) do
  @user = @winning_bidder
  @github_id = @user.github_id
  mock_sign_in(@winning_bidder.github_id, @winning_bidder.name)
end
