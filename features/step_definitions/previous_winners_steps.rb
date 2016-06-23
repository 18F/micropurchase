Then(/^I should see six numbers on the page$/) do
  expect(page).to have_selector(".hero-metrics-wrapper")
  expect(page).to have_selector(:css, "[data-name='auctions_total']")
  expect(page).to have_selector(:css, "[data-name='unique_winners']")
  expect(page).to have_selector(:css, "[data-name='bids']")
  expect(page).to have_selector(:css, "[data-name='bidding_vendors']")
  expect(page).to have_selector(:css, "[data-name='auction_length']")
  expect(page).to have_selector(:css, "[data-name='winning_bid']")
end

Then(/^I should see a section with two donut charts$/) do
  expect(page).to have_selector("#chart-donuts")

  expect(page).to have_selector("#donut-by-repo")
  expect(page).to have_selector("#donut-by-language")
end

Then(/^I should see a Winning bid section$/) do
  expect(page).to have_selector("#chart-winning-bid")

  expect(page).to have_selector("#chart2")
end

Then(/^I should see a Community section$/) do
  expect(page).to have_selector("#chart-community")

  expect(page).to have_selector("#chart4")
end

Then(/^I should see a Bids by auction section$/) do
  expect(page).to have_selector("#chart-bids-by-auction")

  expect(page).to have_selector("#chart5")
end
