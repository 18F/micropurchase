When(/^I visit the auctions admin page$/) do
  visit admin_auctions_path
end

Then(/^I will not see a warning I must be an admin$/) do
  expect(page).to_not have_text('must be an admin')
end

Then(/^I should see the auction$/) do
  expect(page).to have_text(@auction.title)
end

Then(/^I expect my auction changes to have been saved$/) do
  expect(page).to have_text(@title)
  @auction = Auction.where(title: @title).first
end

When(/^I set the auction start price to \$(.+)$/) do |amount|
  fill_in("auction_start_price", with: amount)
end

Then(/^I set the auction type to be multi_bid$/) do
  select("multi_bid", from: "auction_type")
end

When(/^I edit the new auction form$/) do
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

  @start_day = DcTimePresenter.convert(3.days.from_now).strftime("%m/%d/%Y")
  fill_in("auction_start_datetime", with: @start_day)

  @end_day = DcTimePresenter.convert(3.days.from_now).strftime("%m/%d/%Y")
  fill_in("auction_end_datetime", with: @end_day)

  @time_in_days = 3
  @deadline_day = DcTimePresenter.convert(@time_in_days.business_days.from_now).strftime("%m/%d/%Y")
  fill_in("due_in_days", with: @time_in_days)

  @billable = "the tock line item for CALC"
  fill_in("auction_billable_to", with: @billable)

  select("published", from: "auction_published")
end

Then(/^I should be able to edit the existing auction form$/) do
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

  @start_day = DcTimePresenter.convert(Time.now + 3.days).strftime("%m/%d/%Y")
  fill_in("auction_start_datetime", with: @start_day)

  @end_day = DcTimePresenter.convert(Time.now - 3.days).strftime("%m/%d/%Y")
  fill_in("auction_end_datetime", with: @end_day)

  @deadline_day = DcTimePresenter.convert(Time.now + 5.days).strftime("%m/%d/%Y")
  fill_in("auction_delivery_deadline", with: @deadline_day)

  @billable = "the tock line item for CALC"
  fill_in("auction_billable_to", with: @billable)

  select("published", from: "auction_published")
end

When(/^I click to edit the auction$/) do
  click_on("Edit")
  @auction = Auction.where(title: @title).first
end

When(/^I click to create an auction$/) do
  click_on("Create")
  @auction = Auction.where(title: @title).first
end

Then(/^I should see new content on the page$/) do
  expect(page).to have_text(@title)
  expect(page).to have_text(@summary)
  expect(page).to have_text(@description)
end

Then(/^I should see that my auction was created successfully$/) do
  expect(page).to have_content(I18n.t('controllers.admin.auctions.create.success'))
end
