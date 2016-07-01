Then(/^I should see "(.+)"$/) do |text|
  expect(page).to have_content(text)
end

Then(/^I should not see "(.+)"$/) do |text|
  expect(page).to_not have_content(text)
end

Then(/^I should see a message about no auctions$/) do
  expect(page).to have_content(
    "There are no current open auctions on the site. " \
    "Please check back soon to view micropurchase opportunities.")
end

Then(/^I should see a current bid amount( of \$([\d\.]+))?$/) do |_, amount|
  expect(page).to have_content(/Current bid: \$[\d,\.]+/)
  expect(page).to have_content(amount) unless amount.nil?
end

Then(/^I should see a winning bid amount( of \$([\d\.]+))?$/) do |_, amount|
  expect(page).to have_content(/Winning bid \([^\)]+\): \$[\d,\.]+/)
  expect(page).to have_content(amount) unless amount.nil?
end

Then(/^I should see a link to the auction issue URL$/) do
  page.find("a[href='#{@auction.issue_url}']")
end

Then(/^I should see a confirmation for \$(.+)$/) do |amount|
  expect(page).to have_content("Confirm Your Bid")
  expect(page).to have_content("Your bid: $#{amount}")
end

Then(/^I should see a link to give feedback$/) do
  expect(page).to have_link('Feedback')
end

Then(/^I should see an email link to get in touch$/) do
  mailto_link = '//a[@href="mailto:micropurchase@gsa.gov"]'
  expect(page).to have_xpath(mailto_link)
  expect(page).to have_content('micropurchase@gsa.gov')
end

Then(/^I should see a link to the github repository$/) do
  expect(page).to have_link('View Our Code on GitHub')
end

Then(/^I will not see a warning I must be an admin$/) do
  expect(page).to_not have_text('must be an admin')
end

Then(/^I should see the auctions in reverse start date order$/) do
  first_start_date = page.find(:xpath, '/html/body/div/div/div/div/table/tbody/tr[1]/td[3]').text
  second_start_date = page.find(:xpath, '/html/body/div/div/div/div/table/tbody/tr[2]/td[3]').text
  expect(DateTime.parse(first_start_date)).to be > DateTime.parse(second_start_date)
end

Then(/^I should see that user's information$/) do
  expect(page).to have_content(@user.name)
  expect(page).to have_content(@user.email)
  expect(page).to have_content(@user.credit_card_form_url)
  expect(page).to have_content(@user.duns_number)
  expect(page).to have_content(@user.github_id)
  expect(page).to have_content(@user.github_login)
  expect(page).to have_content(@user.sam_status)
end

Then(/^I should see a page title "([^"]+)"$/) do |title|
  expect(page).to have_title title
end

Then(/^I should see a section labeled "([^"]+)"$/) do |header|
  page.find('h2', text: header)
end

Then(/^I should not see a section labeled "([^"]+)"$/) do |header|
  expect(page.first('h2', text: header)).to be_nil
end
