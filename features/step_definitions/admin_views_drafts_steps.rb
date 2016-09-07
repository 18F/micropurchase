Then(/^I should see a table listing all draft auctions$/) do
  table_xpath = '//table[@id="table-drafts"]'
  expect(page).to have_xpath(table_xpath)
end

Then(/^I should see the auction as a draft auction$/) do
  table_xpath = '//table[@id="table-drafts"]'
  within(:xpath, table_xpath) do
    expect(page).to have_content(@auction.title)
  end
end

Then(/^I should see the auction title$/) do
  expect(page).to have_content(@auction.title)
end
