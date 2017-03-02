Then(/^I should see that approval has not been requested for the auction$/) do
  I18n.t('statuses.c2_presenter.not_requested.body', link: '')
end

Then(/^I should see the message that the auction is closed without bids$/) do
  expect(page).to have_content(I18n.t('bidding_status.over.no_bids'))

  expect(page).to have_content(
    I18n.t('statuses.admin_auction_status_presenter.no_bids.body', end_date: end_date)
  )
end
