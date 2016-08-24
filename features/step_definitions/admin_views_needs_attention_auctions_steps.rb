Then(/^I should see the total number of auctions needing my attention next to the needs attention link$/) do
  link = I18n.t('links_and_buttons.auctions.needs_attention')

  expect(page).to have_content("#{link} #{AuctionQuery.new.needs_attention_count}")
end

Then(/^I should see the no number next to the needs attention link$/) do
  link = I18n.t('links_and_buttons.auctions.needs_attention')

  expect(page).to have_content(link)
  expect(page).to_not have_css('span.subnav-number-label')
end
