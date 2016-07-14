Then(/^I should see seven numbers on the page$/) do
  hero_metrics = find('.hero-metrics-wrapper').all('a')
  hero_metrics.size
end

Then(/^I should see a section with two donut charts$/) do
  expect(page).to have_selector("#chart-donuts")

  expect(page).to have_selector("#donut-by-repo")
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
