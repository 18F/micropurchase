Then(/^I should see an? "([^"]*)" text field$/) do |name|
  field = find_field(name)
  expect(field).to_not be_nil
end

When(/^I fill the "([^"]*)" field with "([^"]*)"$/) do |field, value|
  fill_in(field, with: value)
end
