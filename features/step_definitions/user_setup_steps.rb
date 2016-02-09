Given(/^I am a user with a verified SAM account$/) do
  @user = User.create(sam_account: true, duns_number: 'duns123', github_id: '123451')
  sign_in(@user)
end

Given(/^I am a user without a verified sam account$/) do
  @user = User.create(sam_account: false, duns_number: 'duns123', github_id: '123451')
  sign_in(@user)
end

When(/^I visit the home page$/) do
  visit "/"
end

When(/^I sign in$/) do
  step "I visit the home page"
  click_on "registered bidder"
  click_on "Authorize with GitHub »"
end

When(/^I sign in and verify my account information/) do
  step "I sign in"
  click_on "Submit"
end
