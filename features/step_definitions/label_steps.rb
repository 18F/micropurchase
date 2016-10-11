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
