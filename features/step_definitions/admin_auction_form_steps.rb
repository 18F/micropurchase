
When(/^I click on the link to generate a winning bidder CSV report$/) do
  click_on(I18n.t('admin.auctions.show.winner_report'))
end

When(/^I select the result as accepted$/) do
  auction_presenter = AuctionPresenter.new(@auction)
  fake_cap_proposal_attributes = ConstructCapAttributes.new(auction_presenter).perform
  c2_proposal_double = double(id: 8888)
  c2_response_double = double(body: c2_proposal_double)
  c2_client_double = double
  allow(c2_client_double).to receive(:post)
    .with('proposals', fake_cap_proposal_attributes)
    .and_return(c2_response_double)
  allow(C2::Client).to receive(:new).and_return(c2_client_double)

  select("accepted", from: "auction_result")
end

Then(/^I should see that the auction has a CAP Proposal URL$/) do
  expect(find_field(I18n.t('simple_form.labels.auction.cap_proposal_url')).value).to eq(
    @auction.cap_proposal_url
  )
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

  @start_day = DcTimePresenter.convert(3.days.from_now)
  fill_in "auction_started_at", with: @start_day.strftime('%Y-%m-%d')

  @end_day = DcTimePresenter.convert(3.days.from_now)
  fill_in "auction_ended_at", with: @end_day.strftime('%Y-%m-%d')

  @time_in_days = 3
  @deadline_day = DcTimePresenter.convert(@time_in_days.business_days.from_now)
  fill_in("auction_due_in_days", with: @time_in_days)

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

  @start_day = DcTimePresenter.convert(Time.now + 3.days)
  fill_in "auction_started_at", with: @start_day.strftime('%Y-%m-%d')

  @end_day = DcTimePresenter.convert(Time.now - 3.days)
  fill_in "auction_ended_at", with: @end_day.strftime('%Y-%m-%d')

  @deadline_day = DcTimePresenter.convert(Time.now + 5.days)
  fill_in "auction_delivery_due_at", with: @deadline_day.strftime('%Y-%m-%d')

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
