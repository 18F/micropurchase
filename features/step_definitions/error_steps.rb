Then(/^I should see a routing error$/) do
  expect(response).to raise_error(ActionController::RoutingError)
end
