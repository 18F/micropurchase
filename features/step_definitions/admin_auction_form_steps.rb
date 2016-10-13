When(/^I click on the link to generate a winning bidder CSV report$/) do
  click_on(I18n.t('admin.auctions.show.winner_report'))
end

Then(/^I should see that the auction form has a C2 Proposal URL$/) do
  expect(@auction.c2_proposal_url).to be_present
  field = find_field(I18n.t('simple_form.labels.auction.c2_proposal_url'), disabled: true)
  expect(field.value).to eq(@auction.c2_proposal_url)
end

Then(/^I should see that the auction type is sealed bid$/) do
  auction_type = find_field('Type').value
  expect(auction_type).to eq('sealed_bid')
end

Then(/^I should see that the auction form does not have a C2 Proposal URL$/) do
  field = find_field(I18n.t('simple_form.labels.auction.c2_proposal_url'), disabled: true)
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
  select("6", from: "auction_due_in_days")

  select(@billable.to_s, from: "auction_billable_to")

  select(@skill.name, from: "auction_skill_ids")
end

When(/^I change the auction end date on the form$/) do
  @end_day = DefaultDateTime.new(3.business_days.from_now).convert
  fill_in "auction_ended_at", with: @end_day.strftime('%Y-%m-%d')
end

Then(/^I should see an estimated delivery deadline of 12 business days from now$/) do
  within('.estimated-delivery-date') do
    default_delivery_date = DefaultDateTime.new(12.business_days.from_now).convert
    expect(page).to have_content("Estimated delivery date #{DcTimePresenter.convert_and_format(default_delivery_date)}")
  end
end

Then(/^I should see the updated estimate for the delivery deadline$/) do
  within('.estimated-delivery-date') do
    delivery_date = 5.business_days.after(@end_day)
    formatted_delivery_date = DcTimePresenter.format(delivery_date)
    expect(page).to have_content(
      "Estimated delivery date #{formatted_delivery_date}"
    )
  end
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

  select(@billable.to_s, from: "auction_billable_to")
end

When(/^I click to edit the auction$/) do
  click_on("Edit")
end

When(/^I click to create an auction$/) do
  click_on("Create")
  @auction = Auction.last
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

Then(/^I should see a select box with all the customers in the system$/) do
  find_field('Customer')
end

When(/^I select a customer on the form$/) do
  @customer_select = Customer.first
  select(@customer_select.agency_name, from: 'Customer')
end

Then(/^I expect the customer to have been saved$/) do
  @auction.reload
  expect(@auction.customer).to_not be_nil
  expect(@auction.customer).to eq(@customer_select)
end

Then(/^I should see the customer selected for the auction$/) do
  field = find_field('Customer')
  expect(field.value.to_i).to eq(@customer.id)
end

When(/^I select a skill on the form$/) do
  select_selectize_option('auction_skills', @skill.name)
end

Then(/^I should see the skill that I set for the auction selected$/) do
  expect_page_to_have_selected_selectize_option('auction_skills', @skill.name)
end

Then(/^I should see that the form preserves the previously entered values$/) do
  title = find_field('auction_title')
  expect(title.value).to eq(@title)
  description = find_field('auction_description')
  expect(description.value).to eq(@description)
  billable = find_field('auction_billable_to')
  expect(billable.value).to eq(@billable.to_s)
end

When(/^I check the 'Paid' checkbox$/) do
  check('auction_paid_at')
end

When(/^I should see the disabled 'Paid' checkbox$/) do
  expect(page).to have_checked_field('auction_paid_at', disabled: true)
end

When(/^I should not see the 'Paid' checkbox$/) do
  expect(page).not_to have_field('auction_paid_at')
end
