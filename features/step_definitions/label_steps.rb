Then(/^I should see an? "(.+)" status$/) do |label|
  within(:css, 'div.auction-info') do
    expect(page).to have_content(label)
  end
end

Then(/^I should not see an? (.+) status$/) do |label|
  within(:css, 'div.auction-info') do
    expect(page).to_not have_content(label)
  end
end

Then(/^I should see a column labeled "([^"]+)"$/) do |text|
  find('th', text: text)
end

Then(/^I should see an? "([^"]+)" label$/) do |label|
  within(:css, 'div.issue-list-item') do
    within(:css, 'span.usa-label-big') do
      expect(page).to have_content(label)
    end
  end
end
