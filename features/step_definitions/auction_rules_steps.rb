Then(/^I should see that the auction is (Sealed-bid|Reverse)$/) do |type|
  expect(page).to have_content(type)
end

Then(/^I should see the rules for (Sealed-bid|Reverse) auctions$/) do |type|
  expect(page).to have_content("#{type} (rules)")
end
