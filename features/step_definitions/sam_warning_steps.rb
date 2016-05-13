Given(/^a SAM check for my DUNS will (.+)$/) do |action|
  case action
  when 'return true'
    @user.update(duns_number: FakeSamApi::VALID_DUNS)
  when 'return false'
    @user.update(duns_number: FakeSamApi::INVALID_DUNS)
  end
end

Then(/^I should become a valid SAM user$/) do
  @user.reload
  expect(@user).to be_sam_accepted
end

Then(/^I should not become a valid SAM user$/) do
  @user.reload
  expect(@user).to be_sam_rejected
end

Then(/^I should remain a pending SAM user$/) do

  @user.reload
  expect(@user).to be_sam_pending
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
