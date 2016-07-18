Given(/^a SAM check for my DUNS will return true$/) do
  @user.update(duns_number: FakeSamApi::VALID_DUNS)
end

Given(/^a SAM check for my DUNS will return false$/) do
  @user.update(duns_number: FakeSamApi::INVALID_DUNS)
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

Then(/^I should see that my DUNS number is being verified$/) do
  @user.reload
  expect(@user).to be_sam_pending
  expect(page.find(:css, '.pending-verification-status-text').text).to eq "Verifying"
end

Then(/^I should see that my DUNS number was not verified$/) do
  @user.reload
  expect(@user).to be_sam_rejected
  expect(page.find(:css, '.error-verification-status-text').text).to eq "Invalid"
end

Then(/^I should see that my DUNS number was verified$/) do
  @user.reload
  expect(@user).to be_sam_accepted
  expect(page.find(:css, '.verified-verification-status-text').text).to eq "Verified"
end
