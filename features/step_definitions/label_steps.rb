Then(/^I should see an? "(.+)" status$/) do |label|
  within(:css, '.status-label') do
    expect(page).to have_content(label)
  end
end

Then(/^I should see an? "(.+)" label$/) do |label|
  within(:css, '.status-label') do
    expect(page).to have_content(label)
  end
end

Then(/^I should see an? "(.+)" eligibility$/) do |type|
  within(:css, '.auction-info') do
    expect(page).to have_content(type)
  end
end

Then(/^I should not see an? (.+) status$/) do |label|
  within(:css, '.status-label') do
    expect(page).to_not have_content(label)
  end
end

Then(/^I should not see an? (.+) eligibility$/) do |type|
  within(:css, '.auction-info') do
    expect(page).not_to have_content(type)
  end
end

Then(/^I should see a column labeled "([^"]+)"$/) do |text|
  find('th', text: text)
end

Then(/^I should see a relative opening time for the auction$/) do
  relative_time = DcTimePresenter.new(@auction.started_at).relative_time
  expect(page).to have_content("Opens #{relative_time}")
end

Then(/^I should see a relative closing time for the auction$/) do
  relative_time = DcTimePresenter.new(@auction.ended_at).relative_time
  expect(page).to have_content("Closes #{relative_time}")
end

Then(/^I should see the current winning bid in a header subtitle$/) do
  within(:css, '.auction-subtitles') do
    expect(page).to have_content(
      I18n.t('bidding_status.available.bid_label.reverse.default',
             amount: winning_amount,
             bidder_name: winner_name)
    )
  end
end

Then(/^I should not see the current winning bid in a header subtitle$/) do
  within(:css, '.auction-subtitles') do
    expect(page).to_not have_content("Current low bid:")
  end
end

Then(/^I should see I have the current winning bid in a header subtitle$/) do
  within(:css, '.auction-subtitles') do
    expect(page).to have_content(
      I18n.t('bidding_status.available.bid_label.reverse.vendor_winning',
             amount: winning_amount)
    )
  end
end

Then(/^I should see the current winning bid in a header subtitle$/) do
  within(:css, '.auction-subtitles') do
    expect(page).to have_content(
      I18n.t('bidding_status.available.bid_label.reverse.default',
             amount: winning_amount,
             bidder_name: winner_name)
    )
  end
end

Then(/^I should not see the current winning bid in a header subtitle$/) do
  within(:css, '.auction-subtitles') do
    expect(page).to_not have_content("Current low bid:")
  end
end

Then(/^I should see I have the current winning bid in a header subtitle$/) do
  within(:css, '.auction-subtitles') do
    expect(page).to have_content(
      I18n.t('bidding_status.available.bid_label.reverse.vendor_winning',
             amount: winning_amount)
    )
  end
end
