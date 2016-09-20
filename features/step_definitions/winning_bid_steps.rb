Then(/^I should see the winning bid amount$/) do
  winning_bid_amount = Currency.new(winning_bid.amount)

  expect(page).to have_content(winning_bid_amount)
end

Then(/^I should see the winning bidder name$/) do
  winning_bidder_name = winning_bid.bidder.name

  expect(page).to have_content(winning_bidder_name)
end

Then(/^I should see the winning bidder email$/) do
  winning_bidder_email = winning_bid.bidder.email

  expect(page).to have_content(winning_bidder_email)
end
