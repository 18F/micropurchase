Then(/^I should see the rejected auction as an action item$/) do
  auction = Admin::ActionItemListItem.new(@rejected)

  [auction.title, auction.delivery_due_at_expires_in, auction.delivery_url, auction.result,
   auction.cap_proposal_url, auction.paid?].each_with_index do |expected, i|
    within(:xpath, cel_xpath(table_id: 'table-rejected', column: i+1)) do
      expect(page).to have_content(expected)
    end
  end
end
