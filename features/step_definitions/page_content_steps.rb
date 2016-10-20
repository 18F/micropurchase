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

Then(/^I should see the starting price$/) do
  expect(page).to have_content("Starting price: #{Currency.new(@auction.start_price).to_s}")
end

Then(/^I should see a winning bid amount( of \$([\d\.]+))?$/) do |_, amount|
  expect(page).to have_content(/Winning bid \([^\)]+\): \$[\d,\.]+/)
  expect(page).to have_content(amount) unless amount.nil?
end

Then(/^I should see a link to the auction issue URL$/) do
  page.find("a[href='#{@auction.issue_url}']")
end

Then(/^I will not see a warning I must be an admin$/) do
  expect(page).to_not have_text('must be an admin')
end

Then(/^I should see the auctions in reverse start date order$/) do
  first_start_date = Auction.find_by(title: find(:xpath, auction_xpath(1)).text).started_at
  second_start_date = Auction.find_by(title: find(:xpath, auction_xpath(2)).text).started_at
  expect(first_start_date).to be > second_start_date
end

def auction_xpath(position)
  "/html/body/div[2]/div/div[1]/div[#{position}]/div[1]/div/div[1]/div[1]/h3/a"
end

Then(/^I should see a page title "([^"]+)"$/) do |title|
  expect(page).to have_title title
end

Then(/^I should see a page header labeled "([^"]+)"$/) do |header|
  page.find('h1', text: header)
end

Then(/^I should see a section labeled "([^"]+)"$/) do |header|
  page.find('h2', text: header)
end

Then(/^I should not see a section labeled "([^"]+)"$/) do |header|
  expect(page.first('h2', text: header)).to be_nil
end

Then(/^the "([^"]+)" subnav should be selected$/) do |text|
  page.find('a.nav-auction.active', text: text)
end

When(/^I click on the "([^"]+)" subnav$/) do |text|
  click_link(text)
end
