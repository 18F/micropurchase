# coding: utf-8
Given(/^I am a user with a verified SAM account$/) do
  @user = FactoryGirl.create(:user, sam_account: true, github_id: '123451')
  @github_id = @user.github_id
  mock_sign_in(@user.github_id, @user.name)
end

Given(/^I am a user without a verified sam account$/) do
  @user = FactoryGirl.create(:user, sam_account: false, github_id: '123451')
  @github_id = @user.github_id
  mock_sign_in(@user.github_id, @user.name)
end

Given(/^I am an administrator$/) do
  @user = FactoryGirl.create(:admin_user)
  @github_id = @user.github_id
  mock_sign_in(@user.github_id, @user.name)
end

When(/^I visit the home page$/) do
  visit "/"
end

When(/^I sign in$/) do
  step "I visit the home page"
  click_on "registered bidder"
  click_on "Authorize with GitHub »"
end

Given(/^I am signed in$/) do
  step("I sign in")
end

Given(/^I am allowed to bid$/) do
  step("I am a user with a verified SAM account")
  step("I sign in")
end

When(/^I sign in and verify my account information/) do
  step "I sign in"
  click_on "Submit"
end

