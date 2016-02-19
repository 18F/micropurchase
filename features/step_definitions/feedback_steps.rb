Then(/^I should see a link to give feedback$/) do
  expect(page).to have_link('Give Feedback')
end

Then(/^I should see a link to get in touch$/) do
  expect(page).to have_content('Get In Touch')
end

Then(/^I should see a link to the github repository$/) do
  expect(page).to have_link('View Our Code on GitHub')
end
