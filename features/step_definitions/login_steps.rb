Given(/^I only have a Github account$/) do
  @github_id = 12342
  @name = Faker::Name.name

  mock_sign_in(@github_id, @name)
end

Then(/^I expect to see the name from github authentication$/) do
  expect(page).to have_content(@name)
end

Then(/^I expect to see my name$/) do
  expect(page).to have_content(@user.name)
end

Then(/^I expect to not see my name$/) do
  expect(page).to_not have_content(@user.name)
end

Then(/^I expect to see a profile form$/) do
  expect(page).to have_content("Complete your account")
  expect(page).to have_content("Name")
  expect(page).to have_content("DUNS Number")
  expect(page).to have_content("Email Address")
end

Then(/^I expect to see a profile form with my info$/) do
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

Then(/^I expect to see my changes$/) do
  @user = User.where(github_id: @github_id).first
  expect(@user).to_not be_nil
  
  expect(@user.duns_number).to eq(@new_duns)
  expect(@user).to_not be_sam_account
  expect(@user.email).to eq(@new_email)
  expect(@user.name).to eq(@new_name)
  
  expect(page).to have_content(@new_name)
end
