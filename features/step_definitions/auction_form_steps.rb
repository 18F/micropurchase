Then(/^I submit a delivery URL$/) do
  url = "http://www.example.com/pulls/1"
  fill_in('auction_delivery_url', with: url)
  button = I18n.t('auctions.show.status.ready_for_work.form_submit')
  step("I click on the \"#{button}\" button")
end

Then(/^I submit a blank delivery URL$/) do
  url = ""
  fill_in('auction_delivery_url', with: url)
  button = I18n.t('auctions.show.status.ready_for_work.form_submit')
  step("I click on the \"#{button}\" button")
end
