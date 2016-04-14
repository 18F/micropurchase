Given(/^I only have a Github account$/) do
  @github_id = 12342
  @name = Faker::Name.name

  mock_sign_in(@github_id, @name)
end

Then(/^I should see the name from github authentication$/) do
  field = find_field('Name')
  expect(field.value).to eq(@name)
end

Then(/^I should see my name$/) do
  expect(page).to have_content(@user.name)
end

Then(/^I should not see my name$/) do
  expect(page).to_not have_content(@user.name)
end

Then(/^I should see my email address$/) do
  expect(page).to have_content(@user.email)
end

Then(/^I should see a profile form$/) do
  expect(page).to have_content("Complete your account")
  expect(page).to have_content("Name")
  expect(page).to have_content("DUNS Number")
  expect(page).to have_content("Email Address")
end

Then(/^I should see a profile form with my info$/) do
  expect(page).to have_content("Complete your account")

  field = find_field('Name')
  expect(field.value).to eq(@user.name)
  field = find_field("DUNS Number")
  expect(field.value).to eq(@user.duns_number)
  field = find_field("Email Address")
  expect(field.value).to eq(@user.email)
end

When(/^I fill out the profile form$/) do
  @new_name = Faker::Name.name
  @new_duns = Faker::Company.duns_number
  @new_email = Faker::Internet.email

  expect(page).to have_content("Enter your DUNS number")
  fill_in("user_name", with: @new_name)
  fill_in("user_duns_number", with: @new_duns)
  fill_in("user_email", with: @new_email)
end

When(/^I fill the "([^"]*)" field with "([^"]*)"$/) do |field, value|
  fill_in(field, with: value)
end

When(/^there is no (.+) associated with my account$/) do |attribute|
  attribute = attribute.parameterize('_')
  @user.update_attribute(attribute, nil)
end

def fake_value_for_attribute(attribute)
  case attribute
  when 'credit_card_form_url'
    Faker::Internet.url
  when 'name'
    Faker::Name.name
  when 'duns_number'
    Faker::Company.duns_number
  when 'email'
    Faker::Internet.email
  else
    fail "Unknown attribute '#{attribute}'"
  end
end

When(/^there is a (.+) associated with my account$/) do |attr|
  attribute = attr.parameterize('_')
  @user.update_attribute(attribute, fake_value_for_attribute(attribute))
end

When(/^I fill in the (.+) field on my profile page$/) do |attribute|
  attribute = attribute.parameterize('_')
  value = fake_value_for_attribute(attribute)

  @new_values ||= {}
  @new_values[attribute] = value
  
  step("I fill in the \"user_#{attribute}\" field with \"#{value}\"")
end

When(/^I fill in the "(.+)" field with "([^"]*)"$/) do |field, value|
  fill_in(field, with: value)
end

Then(/^the new value should be stored as my (.+)$/) do |attribute|
  attribute = attribute.parameterize('_')
  field = find_field("user_#{attribute}")

  expect(@new_values).to_not be_nil
  expect(@new_values[attribute]).to_not be_nil
  expect(field.value).to eq(@new_values[attribute])
end
  
Then(/^I should see "([^"]*)" in the "([^"]*)" field$/) do |value, field|
  field = find_field(field)
  expect(field.value).to eq(value)
end

Then(/^I should see my (.+) in the "([^"]*)" field$/) do |attribute, field|
  @user.reload
  attribute = attribute.parameterize('_')
  field = find_field(field)
  expect(field.value).to eq(@user.send(attribute))
end

Then(/^I should see an alert that "([^"]*)"$/) do |message|
  within("div.usa-alert.usa-alert-error") do
    expect(page).to have_content(message)
  end
end

Then(/^I should see my changes$/) do
  @user = User.where(github_id: @github_id).first
  expect(@user).to_not be_nil

  expect(@user.duns_number).to eq(@new_duns)
  expect(@user).to_not be_sam_account
  expect(@user.email).to eq(@new_email)
  expect(@user.name).to eq(@new_name)

  expect(page).to have_content(@new_name)
end
