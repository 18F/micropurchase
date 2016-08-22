Then(/^I should see a table listing all draft auctions$/) do
  table_xpath = '/html/body/div[2]/div/table'
  expect(page).to have_xpath(table_xpath)
end

Then(/^I should see the auction title$/) do
  expect(page).to have_content(@auction.title)
end
