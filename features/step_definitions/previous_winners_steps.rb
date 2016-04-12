When(/^I visit the previous winners page$/) do
  visit "/auctions/winners/"
end

When(/^I visit the previous winners archive page$/) do
  visit "/auctions/winners/archive/"
end

Then(/^I should visit the previous winners archive page$/) do
  visit "/auctions/winners/archive/"
end

Then(/^I should see a link to the previous winners archive page$/) do
  expect(page).to have_link('See all previous winners')
end

Then(/^I click on the previous winners link$/) do
  first(:link, 'See all previous winners').click
end


Then(/^I should see six numbers on the page$/) do
  expect(page).to have_selector(".hero-metrics_wrapper")

  auctions_total = page.find(:css, "[data-name='auctions_total']")
  unique_winners = page.find(:css, "[data-name='unique_winners']")
  bids = page.find(:css, "[data-name='bids']")
  bidding_vendors = page.find(:css, "[data-name='bidding_vendors']")
  auction_length = page.find(:css, "[data-name='auction_length']")
  winning_bid = page.find(:css, "[data-name='winning_bid']")

  expect(auctions_total).to have_content()
  expect(unique_winners).to have_content()
  expect(bids).to have_content()
  expect(bidding_vendors).to have_content()
  expect(auction_length).to have_content()
  expect(winning_bid).to have_content()
end


Then(/^I should see a section with two donut charts$/) do
  expect(page).to have_selector("#chart-donuts")

  by_repo = page.find(:css, "#donut-by-repo")
  by_language = page.find(:css, "#donut-by-language")

  expect(page).to have_selector("#donut-by-repo")
  expect(page).to have_selector("#donut-by-language")

  expect(by_repo).to have_content()
  expect(by_language).to have_content()
end

Then(/^I should see a Winning bid section$/) do
  expect(page).to have_selector("#chart-winning-bid")

  chart2 = page.find(:css, "#chart2")

  expect(page).to have_selector("#chart2")

  expect(chart2).to have_content()
end

Then(/^I should see a Community section$/) do
  expect(page).to have_selector("#chart-community")

  chart4 = page.find(:css, "#chart4")

  expect(page).to have_selector("#chart4")

  expect(chart4).to have_content()
end

Then(/^I should see a Bids by auction section$/) do
  expect(page).to have_selector("#chart-bids-by-auction")

  chart5 = page.find(:css, "#chart5")

  expect(page).to have_selector("#chart5")

  expect(chart5).to have_content()
end


Then(/^I should see a dropdown menu$/) do
  expect(page).to have_selector("form.winners-filter")
end

Then(/^the menu should default to All$/) do
  expect(page).to have_selector("form.winners-filter")

  dropdown = page.find(:css, "form.winners-filter")

  expect(dropdown).to have_content('All')
end

Then(/^I should see a list of all the previous auctions$/) do
  expect(page).to have_selector(".winners-list-item")

  previous_auction_item = first(:css, ".winners-list-item")

  expect(previous_auction_item).to have_content()
end




