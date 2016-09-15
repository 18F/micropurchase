Then(/^I should see a table listing all draft auctions$/) do
  table_xpath = '//table[@id="table-drafts"]'
  expect(page).to have_xpath(table_xpath)
end

Then(/^I should see the auction as an unpublished auction that is ready to be published$/) do
  expect(page).to have_content(
    I18n.t('statuses.admin_auction_status_presenter.future.unpublished.header')
  )
end

Then(/^I should see the auction title$/) do
  expect(page).to have_content(@auction.title)
end
