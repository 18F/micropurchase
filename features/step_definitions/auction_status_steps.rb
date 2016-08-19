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

Then(/^I should see the pending payment status box$/) do
  expect(page).to have_content(
    I18n.t('auctions.show.status.pending_payment.header')
  )
end

Then(/^I should see that the C2 status for an auction pending C2 approval$/) do
  expect(page).to have_content(
    I18n.t('statuses.c2_presenter.pending.body')
  )
end

Then(/^I should see the C2 status for an auction pending payment confirmation$/) do
  expect(page).to have_content(
    I18n.t('statuses.c2_presenter.c2_paid.header')
  )
end

Then(/^I should see the C2 status for an auction with payment confirmation$/) do
  paid_at = DcTimePresenter.convert_and_format(@auction.paid_at)
  accepted_date = DcTimePresenter.convert_and_format(@auction.accepted_at)
  winning_bid = WinningBid.new(@auction).find
  winner_email = winning_bid.bidder.email
  amount = Currency.new(winning_bid.amount)

  expect(page).to have_content(
    I18n.t(
      'statuses.c2_presenter.payment_confirmed.body',
      winner_email: winner_email,
      accepted_date: accepted_date,
      amount: amount,
      paid_at: paid_at
    )
  )
end

Then(/^I should see the open auction message for vendors not verified by Sam\.gov$/) do
  expect(page).to have_content(
    I18n.t('auctions.show.status.open.vendor.not_verified.header')
  )
end

Then(/^I should see the open auction message for vendors who are not small businesses$/) do
  expect(page).to have_content(
    I18n.t('auctions.show.status.open.vendor.not_small_business.header')
  )
end

Then(/^I should see the payment confirmation needed message$/) do
  expect(page).to have_content(
    I18n.t('auctions.show.status.payment_confirmation_needed.header')
  )
end


Then(/^I should see the payment confirmed message$/) do
  expect(page).to have_content(
    I18n.t('auctions.show.status.payment_confirmed.header')
  )
  expect(page).to have_content(
    I18n.t(
      'auctions.show.status.payment_confirmed.body',
      end_date: end_date,
      accepted_date: DcTimePresenter.convert_and_format(@auction.accepted_at),
      amount: Currency.new(WinningBid.new(@auction).find.amount),
      paid_at: DcTimePresenter.convert_and_format(@auction.paid_at)
    )
  )
end

def end_date
  DcTimePresenter.convert_and_format(@auction.ended_at)
end

def start_date
  DcTimePresenter.convert_and_format(@auction.started_at)
end
