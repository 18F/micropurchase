# coding: utf-8
Given(/^I am a user with a verified SAM account$/) do
  @user = FactoryGirl.create(:user, sam_account: true, duns_number: 'duns123', github_id: '123451')
  sign_in(@user)
end

Given(/^I am a user without a verified sam account$/) do
  @user = FactoryGirl.create(:user, sam_account: false, duns_number: 'duns123', github_id: '123451')
  sign_in(@user)
end

Given(/^I am an administrator$/) do
  @user = FactoryGirl.create(:admin_user)
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
  @auction = FactoryGirl.create(:auction, :with_bidders)
end

When(/^I visit the auction$/) do
  visit "/auctions/#{@auction.id}"
end

When(/^I click on the auction$/) do
  click_on(@auction.title)
end

Then(/^I expect to see the winning bid for the auction$/) do
  auction = Presenter::Auction.new(@auction)
  current_bid_amount = ApplicationController.helpers.number_to_currency(
    auction.current_bid.amount
  )

  expect(page).to have_text(current_bid_amount)
end

Then(/^I expect to see the description for the auction$/) do
  expect(page).to have_text(@auction.description)
end

Then(/^I expect to see the auction deadline$/) do
  expect(page).to have_text(
                    Presenter::DcTime.convert(@auction.end_datetime).
                    beginning_of_day.strftime(Presenter::DcTime::FORMAT)
                  )
end
