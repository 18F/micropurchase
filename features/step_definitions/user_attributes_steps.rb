Given(/^I only have a Github account$/) do
  @github_id = 12342
  @name = Faker::Name.name

  mock_sign_in(@github_id, @name)
end

Then(/^I should see the name from github authentication$/) do
  field = find_field('Name')
  expect(field.value).to eq(@name)
end

Then(/^I should see "([^"]+)" for the user in the "([^"]+)" column$/) do |value, column|
  user_admin_columns = ['Name', 'Email address', 'DUNS #', 'Small business', 'SAM status']

  index = user_admin_columns.index(column)
  fail 'Unrecognized column: #{column}' if index.nil?
  css = "tr td:nth-child(#{index + 1})"

  within(:xpath, '/html/body/div/div/table[1]') do
    within(css) do
      expect(page).to have_content(value)
    end
  end
end

When(/^there is a (.+) associated with my account$/) do |attr|
  attribute = attr.parameterize('_')
  @user.update_attribute(attribute, fake_value_for_user_attribute(attribute))
end
