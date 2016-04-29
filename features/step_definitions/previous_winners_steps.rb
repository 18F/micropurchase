When(/^I visit the previous winners page$/) do
  visit "/auctions/winners/"
end

When(/^I visit the previous winners archive page$/) do
  visit "/auctions/winners/archive/"
end

Then(/^I should be at previous winners archive page$/) do
  current_path.should == "/auctions/winners/archive/"
end

Then(/^I should see a link to the previous winners archive page$/) do
  expect(page).to have_link('See all previous winners')
end

Then(/^I click on the previous winners link$/) do
  first(:link, 'See all previous winners').click
end

Then(/^I should see six numbers on the page$/) do
  expect(page).to have_selector(".hero-metrics_wrapper")

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
end
