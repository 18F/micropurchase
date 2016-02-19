# coding: utf-8
Given(/^I am a user with a verified SAM account$/) do
  @user = FactoryGirl.create(:user, sam_account: true, duns_number: 'duns123', github_id: '123451')
  sign_in(@user)
end

Given(/^I am a user without a verified sam account$/) do
  @user = FactoryGirl.create(:user, sam_account: false, duns_number: 'duns123', github_id: '123451')
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

Given(/^there is an open auction$/) do
  @auction = FactoryGirl.create(:auction,
                                start_datetime: Time.now - 3.days,
                                end_datetime: Time.now + 3.days,
                                title: 'an auction')
end

When(/^I visit a the open auction$/) do
  visit "/auctions/#{@auction.id}"
end
