When(/^I should see my user info$/) do
  user = UserPresenter.new(@user)

  expect(page).to have_text(user.duns_number)
  expect(page).to have_text(user.email)
  expect(page).to have_text(user.name)
  expect(page).to have_text(user.github_id)
  expect(page).to have_text(user.in_sam?)
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
  @new_email = "random#{rand(10000)}@example.com"

  fill_in("user_name", with: @new_name)
  fill_in("user_duns_number", with: @new_duns)
  fill_in("user_email", with: @new_email)
end

When(/^there is no (.+) associated with my account$/) do |attribute|
  attribute = attribute.parameterize('_')
  @user.update(attribute.to_sym => '')
end

Then(/^my (.+) should not be set$/) do |attribute|
  attribute = attribute.parameterize('_')
  expect(@user.send(attribute)).to be_blank
end

When(/^I fill in the (.+) field on my profile page$/) do |attribute|
  attribute = attribute.parameterize('_')
  value = fake_value_for_user_attribute(attribute)
  step("I fill in the #{attribute} field on my profile page with \"#{value}\"")
end

When(/^I fill in the (.+) field on my profile page with "([^"]+)"$/) do |attribute, value|
  attribute = attribute.parameterize('_')
  @new_values ||= { }
  @new_values[attribute] = value

  step("I fill the \"user_#{attribute}\" field with \"#{value}\"")
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

Then(/^I enter an? (.+) DUNS in my profile$/) do |duns_type|
  case duns_type
  when 'valid'
    @new_duns = FakeSamApi::VALID_DUNS
  when 'invalid'
    @new_duns = FakeSamApi::INVALID_DUNS
  when 'new'
    @new_duns = Faker::Company.duns_number
  end
  fill_in("user_duns_number", with: @new_duns)
end
