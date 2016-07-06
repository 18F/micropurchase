Given(/^there is a customer$/) do
  @customer = FactoryGirl.create(:customer)
end

Then(/^I should see the customer name on the page$/) do
  page.find('p.auction-label-info', text: @customer.agency_name)
end

Then(/^I should not see a label for the customer on the page$/) do
  expect(page.first('h6', text: 'Customer')).to be_nil
end
