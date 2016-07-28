When(/^I click the edit user link next to the first non-admin user$/) do
  within(:xpath, cel_xpath(table_id: 'table-users', row: 1, column: 7)) do
    click_on "Edit"
  end
end

When(/^I click the edit user link next to the first admin user$/) do
  within(:xpath, cel_xpath(table_id: 'table-admins', row: 1, column: 4)) do
    click_on "Edit"
  end
end

When(/^I check the 'Contracting officer' checkbox$/) do
  check('user_contracting_officer')
end

When(/^I submit the changes to the user$/) do
  click_on "Update"
end

Then(/^I expect there to be a contracting officer in the list of admin users$/) do
  within(:xpath, '//table[@id="table-admins"]') do
    within(:css, "tr td:nth-child(3)") do
      expect(page).to have_content("true")
    end
  end
end
