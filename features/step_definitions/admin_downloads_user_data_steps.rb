Then(/^I should receive a CSV file$/) do
  expect(page.response_headers['Content-Type']).to include('text/csv')
end

Then(/^the file should contain non-admin user data$/) do
  expect(page.response_headers["Content-Disposition"]).to include("attachment")

  parsed = CSV.parse(page.source)

  expect(parsed.length).to eq(2)
  expect(parsed[0]).to eq(["Name", "Email Address", "Github ID", "In SAM?", "Small Business"])

  user = UserPresenter.new(@user)
  expect(parsed[1]).to eq([user.name, user.email, user.github_id, user.sam_status_label, user.small_business_label])
end
