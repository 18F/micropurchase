Then(/^I should see the open auction message for guests$/) do
  expect(page).to have_content(
    "This auction is accepting bids until #{end_date}. Sign in or sign up with GitHub to bid."
  )
end

Then(/^I should see the future auction message for guests$/) do
  expect(page).to have_content(
    "This auction starts on #{start_date}. Sign in or sign up with GitHub to bid."
  )
end

Then(/^I should see the future auction message for vendors$/) do
  expect(page).to have_content(
    I18n.t('auctions.status.future.vendor.body', start_date: start_date)
  )
end

Then(/^I should see the future auction message for admins$/) do
  expect(page).to have_content(
    "This auction is visible to the public but is not currently accepting bids.
    It will open on #{start_date}. If you need to take it down for whatever
    reason, press the unpublish button below."
  )
end

Then(/^I should the open auction message for admins$/) do
  expect(page).to have_content(
    "This auction is accepting bids until #{end_date}."
  )
end

Then(/^I should see the time I placed my bid$/) do
  bid = @auction.bids.last

  expect(page).to have_content(
    "You bid #{Currency.new(bid.amount)} on #{DcTimePresenter.convert_and_format(bid.created_at)}."
  )
end

def end_date
  DcTimePresenter.convert_and_format(@auction.ended_at)
end

def start_date
  DcTimePresenter.convert_and_format(@auction.started_at)
end
