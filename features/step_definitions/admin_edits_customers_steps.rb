Then(/^the customer should not be created$/) do
  expect(Customer.count).to eq(0)
end

Then(/^the customer should be created$/) do
  expect(Customer.count).to eq(1)
end

When(/^I fill in values for a new customer$/) do
  @agency_name = 'Federal Testing Corp.'
  fill_in("Agency name", with: @agency_name)
  @contact_name = Faker::Name.name
  fill_in("Contact name", with: @contact_name)
  @email = Faker::Internet.email
  fill_in("Email", with: @email)
end

Then(/^I should see the new customer on the page$/) do

  within(:xpath, cel_xpath(column: 1)) do
    expect(page).to have_content(@agency_name)
  end

  within(:xpath, cel_xpath(column: 2)) do
    expect(page).to have_content(@contact_name)
  end

  within(:xpath, cel_xpath(column: 3)) do
    expect(page).to have_content(@email)
  end
end
