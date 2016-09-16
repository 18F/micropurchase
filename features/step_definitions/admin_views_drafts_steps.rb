Then(/^I should see a table listing all draft auctions$/) do
  expect(page).to have_xpath(needs_attention_table_xpath('drafts'))
end

Then(/^I should see the auction as an unpublished auction that is ready to be published$/) do
  expect(page).to have_content(
    I18n.t('statuses.admin_auction_status_presenter.future.unpublished.header')
  )
end

Then(/^I should see the auction as a draft auction$/) do
  table_xpath = needs_attention_table_xpath('drafts')

  within(:xpath, table_xpath) do
    expect(page).to have_content(@auction.title)
  end
end

Then(/^I should see a table listing all payment needed auctions$/) do
  expect(page).to have_xpath(needs_attention_table_xpath('payment_needed'))
end

Then(/^I should see the auction as a payment needed auction$/) do
  table_xpath = needs_attention_table_xpath('payment_needed')
  within(:xpath, table_xpath) do
    expect(page).to have_content(@auction.title)
  end
end

Then(/^I should see the auction title$/) do
  expect(page).to have_content(@auction.title)
end
