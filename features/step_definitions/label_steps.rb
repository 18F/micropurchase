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
