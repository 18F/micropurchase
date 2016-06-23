When(/^I click the edit user link next to the first non-admin user$/) do
  within(:xpath, '/html/body/div/div/div/div/div/table[2]/tbody/tr[1]/td[7]') do
    click_on "Edit"
  end
end

When(/^I click the edit user link next to the first admin user$/) do
  within(:xpath, '/html/body/div/div/div/div/div/table[1]/tbody/tr[1]/td[7]') do
    click_on "Edit"
  end
end

When(/^I check the 'Contracting officer' checkbox$/) do
  check('user_contracting_officer')
end

When(/^I submit the changes to the user$/) do
  click_on "Update User"
end

Then(/^I expect there to be a contracting officer in the list of admin users$/) do
  within(:xpath, '/html/body/div/div/div/div/div/table[1]') do
    within(:css, "tr td:nth-child(5)") do
      expect(page).to have_content("true")
    end
  end
end

