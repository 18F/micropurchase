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
