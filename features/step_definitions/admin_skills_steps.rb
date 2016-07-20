When(/^there is a skill for "([^"]*)" already$/) do |name|
  FactoryGirl.create(:skill, name: name)
end

Then(/^I should see "([^"]*)" in the list of skills$/) do |name|
  within(:xpath, cel_xpath(column: 1)) do
    expect(page).to have_content(name)
  end
end
