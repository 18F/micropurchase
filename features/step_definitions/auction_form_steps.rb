Then(/^I submit a delivery URL$/) do
  url = "http://www.example.com/pulls/1"
  fill_in('auction_delivery_url', with: url)
  button = I18n.t('statuses.bid_status_presenter.over.winner.work_not_started.form_submit')
  step("I click on the \"#{button}\" button")
end

Then(/^I submit a blank delivery URL$/) do
  url = ""
  fill_in('auction_delivery_url', with: url)
  button = I18n.t('statuses.bid_status_presenter.over.winner.work_not_started.form_submit')
  step("I click on the \"#{button}\" button")
end

When(/^I mark the auction as rejected$/) do
  button = I18n.t('statuses.bid_status_presenter.over.admin.pending_acceptance.actions.reject')
  step("I click on the \"#{button}\" button")
end

When(/^I mark the auction as accepted$/) do
  button = I18n.t('statuses.bid_status_presenter.over.admin.pending_acceptance.actions.accept')
  step("I click on the \"#{button}\" button")
end
