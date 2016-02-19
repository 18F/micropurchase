When(/^I visit the auctions admin page$/) do
  visit "/admin/auctions"
end

Then(/^I will not see a warning I must be an admin$/) do
  expect(page).to_not have_text('must be an admin')
end

Then(/^I expect to see the auction$/) do
  expect(page).to have_text(@auction.title)
end

Then(/^I expect to see the auction with the new title$/) do
  expect(page).to have_text(@title)
  @auction = Auction.where(title: @title).first
end

Then(/^I set the auction type to be multi_bid$/) do
  select("multi_bid", from: "auction_type")
end

Then(/^I should be able to fill out a form for the auction$/) do
  @title = 'This is the form-edited title'
  fill_in("auction_title", with: @title)

  @description = 'and the admin related stuff'
  fill_in("auction_description", with: @description)

  @repo = 'https://github.com/18F/calc'
  fill_in('auction_github_repo', with: @repo)

  @summary = 'The Summary!'
  fill_in('auction_summary', with: @summary)

  @issue_url = 'https://github.com/18F/calc/issues/255'
  fill_in('auction_issue_url', with: @issue_url)

  @start_day = Presenter::DcTime.convert(Time.now + 3.days).strftime("%m/%d/%Y")
  fill_in("auction_start_datetime", with: @start_day)

  @end_day = Presenter::DcTime.convert(Time.now - 3.days).strftime("%m/%d/%Y")
  fill_in("auction_end_datetime", with: @end_day)

  @deadline_day = Presenter::DcTime.convert(Time.now + 5.days).strftime("%m/%d/%Y")
  fill_in("auction_delivery_deadline", with: @deadline_day)

  @billable = "the tock line item for CALC"         
  fill_in("auction_billable_to", with: @billable)

  select("published", from: "auction_published")
end

Then(/^I expect to see the changes$/) do
  expect(page).to have_text(@title)
  expect(page).to have_text(@summary)
  expect(page).to have_text(@description)
end

When(/^I click to create a new auction$/) do
  find_link('Create a new auction').click
end

When(/^I click on edit$/) do
  click_on("Edit")
  @auction = Auction.where(title: @title).first
end

When(/^I click on create$/) do
  click_on("Create")
  @auction = Auction.where(title: @title).first
end

When(/^I click on update$/) do
  click_on('Update')
end
