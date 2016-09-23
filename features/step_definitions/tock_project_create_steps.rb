Given(/^there is a client account to bill to$/) do
  @billable = FactoryGirl.create(:client_account, active: true)
end

Given(/^there is a non\-active client account$/) do
  @non_active = FactoryGirl.create(:client_account, active: false)
end
