Given(/^there is a client account to bill to$/) do
  @billable = FactoryGirl.create(:client_account)
end
