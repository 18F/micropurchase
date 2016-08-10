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

Then(/^I should see the ready for work status box$/) do
  expect(page).to have_content(
    I18n.t('auctions.show.status.ready_for_work.header')
  )
  expect(find_field('auction_delivery_url')).not_to be_nil
end

Then(/^I should see the work in progress status box$/) do
  expect(page).to have_content(
    I18n.t('auctions.show.status.work_in_progress.header')
  )
end

Then(/^I should see the pending acceptance status box$/) do
  expect(page).to have_content(
    I18n.t('auctions.show.status.pending_acceptance.header')
  )
end

Then(/^I should see that the C2 status for an auction pending C2 approval$/) do
  expect(page).to have_content(
    I18n.t('statuses.c2_presenter.pending.body')
  )
end

def end_date
  DcTimePresenter.convert_and_format(@auction.ended_at)
end

def start_date
  DcTimePresenter.convert_and_format(@auction.started_at)
end
