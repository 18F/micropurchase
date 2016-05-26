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

Then(/^the file should contain the following data from Sam\.gov:$/) do |content|
  expect(page.response_headers["Content-Disposition"]).to include("attachment")
  content.split(',').each do |info|
    expect(page.source).to include(info.strip)
  end
end
