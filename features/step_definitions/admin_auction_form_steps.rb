
When(/^I click on the link to generate a winning bidder CSV report$/) do
  click_on(I18n.t('admin.auctions.show.winner_report'))
end

When(/^I select the result as accepted$/) do
  select("accepted", from: "auction_result")
end

Then(/^I should see that the auction form has a CAP Proposal URL$/) do
  expect(@auction.cap_proposal_url).to be_present
  field = find_field(I18n.t('simple_form.labels.auction.cap_proposal_url'), disabled: true)
  expect(field.value).to eq(@auction.cap_proposal_url)
end

Then(/^I should see that the auction form does not have a CAP Proposal URL$/) do
  field = find_field(I18n.t('simple_form.labels.auction.cap_proposal_url'), disabled: true)
  expect(field.value).to eq('')
end

Then(/^I expect my auction changes to have been saved$/) do
  expect(page).to have_text(@title)
  @auction = Auction.where(title: @title).first
end

When(/^I set the auction start price to \$(.+)$/) do |amount|
  fill_in("auction_start_price", with: amount)
end

Then(/^I set the auction type to be reverse$/) do
  select("reverse", from: "auction_type")
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
  select('11', from: 'auction_started_at_1i')
  select('30', from: 'auction_started_at_2i')
  select('AM', from: 'auction_started_at_3i')
  @start_time = DcTimePresenter.time_zone.parse("#{@start_day.strftime('%Y-%m-%d')} 11:30 AM")

  @end_day = DcTimePresenter.convert(3.days.from_now)
  fill_in "auction_ended_at", with: @end_day.strftime('%Y-%m-%d')
  select('4', from: 'auction_ended_at_1i')
  select('45', from: 'auction_ended_at_2i')
  select('PM', from: 'auction_ended_at_3i')
  @end_time = DcTimePresenter.time_zone.parse("#{@start_day.strftime('%Y-%m-%d')} 4:45 PM")

  @time_in_days = 3
  @deadline_day = DcTimePresenter.convert(@time_in_days.business_days.from_now)
  fill_in("auction_due_in_days", with: @time_in_days)

  select(@billable.to_s, from: "auction_billable_to")
  select("published", from: "auction_published")
end

Then(/^I should see the current auction attributes in the form$/) do
  expect(@auction).to_not be_nil

  %w(issue_url description github_repo summary issue_url billable_to).each do |field|
    form_field = find_field("auction_#{field}")
    expect(form_field.value).to eq(@auction.send(field))
  end

  started_at = DcTimePresenter.convert(@auction.started_at)
  expect(find_field('auction_started_at').value).to    eq(started_at.strftime('%Y-%m-%d'))
  expect(find_field('auction_started_at_1i').value).to eq(started_at.strftime('%l').strip)
  expect(find_field('auction_started_at_2i').value).to eq(started_at.strftime('%M').strip)
  expect(find_field('auction_started_at_3i').value).to eq(started_at.strftime('%p'))

  ended_at = DcTimePresenter.convert(@auction.ended_at)
  expect(find_field('auction_ended_at').value).to    eq(ended_at.strftime('%Y-%m-%d'))
  expect(find_field('auction_ended_at_1i').value).to eq(ended_at.strftime('%l').strip)
  expect(find_field('auction_ended_at_2i').value).to eq(ended_at.strftime('%M').strip)
  expect(find_field('auction_ended_at_3i').value).to eq(ended_at.strftime('%p'))
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
  select('12', from: 'auction_started_at_1i')
  select('30', from: 'auction_started_at_2i')
  select('PM', from: 'auction_started_at_3i')
  @start_time = DcTimePresenter.time_zone.parse("#{@start_day.strftime('%Y-%m-%d')} 12:30 PM")

  @end_day = DcTimePresenter.convert(Time.now + 8.days)
  fill_in "auction_ended_at", with: @end_day.strftime('%Y-%m-%d')
  select('5', from: 'auction_ended_at_1i')
  select('30', from: 'auction_ended_at_2i')
  select('PM', from: 'auction_ended_at_3i')
  @end_time = DcTimePresenter.time_zone.parse("#{@end_day.strftime('%Y-%m-%d')} 5:30 PM") 

  @deadline_day = DcTimePresenter.convert(Time.now + 5.days)
  fill_in "auction_delivery_due_at", with: @deadline_day.strftime('%Y-%m-%d')

  select(@billable.to_s, from: "auction_billable_to")
  select("published", from: "auction_published")
end

When(/^I click to edit the auction$/) do
  click_on("Edit")
end

When(/^I click to create an auction$/) do
  click_on("Create Auction")
  @auction = Auction.where(title: @title).first
end

Then(/^I should see new content on the page$/) do
  expect(page).to have_text(@title)
  expect(page).to have_text(@summary)
  expect(page).to have_text(@description)
  expect(page).to have_text(@billable.to_s)
end

Then(/^I should see that my auction was created successfully$/) do
  expect(page).to have_content(I18n.t('controllers.admin.auctions.create.success'))
end

Then(/^I should see the start time I set for the auction$/) do
  expect(DcTimePresenter.convert_and_format(@auction.started_at)).to eq(DcTimePresenter.convert_and_format(@start_time))
  expect(page).to have_text(DcTimePresenter.convert_and_format(@start_time))
end

Then(/^I should see the end time I set for the auction$/) do
  expect(DcTimePresenter.convert_and_format(@auction.ended_at)).to eq(DcTimePresenter.convert_and_format(@end_time))
  expect(page).to have_text(DcTimePresenter.convert_and_format(@end_time))
end
