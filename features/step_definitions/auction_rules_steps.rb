Then(/^I should see a link to (single-bid|multi-bid) rules$/) do |rules|
  case rules
  when 'single-bid'
    expect(page).to have_content("Single-bid")
  when 'multi-bid'
    expect(page).to have_content("Multi-bid")
  else
    fail "Unrecognized auction type: #{rules}"
  end
end

Then(/^I should see the rules for (single-bid|multi-bid) auctions$/) do |type|
  expect(page).to have_content("Rules for #{type} auctions")
end
