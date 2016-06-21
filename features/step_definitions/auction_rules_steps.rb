Then(/^I should see that the auction is (Single-bid|Multi-bid)$/) do |type|
  expect(page).to have_content(type)
end

Then(/^I should see the rules for (Single-bid|Multi-bid) auctions$/) do |type|
  expect(page).to have_content("#{type} (rules)")
end
