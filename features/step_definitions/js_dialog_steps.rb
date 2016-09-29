When(/^I click OK on the javascript confirm dialog for a bid amount of (.+)$/) do |amount|
  text = "Are you sure you want to place a bid for #{amount}?"
  page.accept_alert(text)
end

When(/^I click OK on the javascript confirm dialog to archive the auction$/) do
  text = 'Are you sure you want to archive this auction?'
  page.accept_alert(text)
end
