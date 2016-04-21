Then(/^I should see an alert that "([^"]*)"$/) do |message|
  within("div.usa-alert.usa-alert-error") do
    expect(page).to have_content(message)
  end
end

Then(/^I should see an alert that my DUNS number was not found in Sam\.gov$/) do
  within("div.usa-alert.usa-alert-error") do
    expect(page).to have_content(
      "Your DUNS number was not found in Sam.gov. Please enter
      a valid DUNS number to complete your profile. Check
      https://www.sam.gov/sam/helpPage/SAM_Reg_Status_Help_Page.html to make
      sure your DUNS number is correct. If you need any help email us at
      micropurchase@gsa.gov"
    )
  end
end

Then(/^I should see a warning that "([^"]*)"$/) do |message|
  within("div.usa-alert.usa-alert-warning") do
    expect(page).to have_content(message)
  end
end

Then(/^I should see a success message that "([^"]*)"$/) do |message|
  within("div.usa-alert.usa-alert-success") do
    expect(page).to have_content(message)
  end
end

