Then(/^I should see the rejected auction as a needs attention auction$/) do
  auction = Admin::NeedsAttentionAuctionListItem.new(@auction)

  ['Title', 'Delivery Deadline', 'Delivery URL', 'Vendor Name', 'Rejected At'].each_with_index do |header, i|
    within(:xpath, th_xpath(table_id: 'table-rejected', column: i + 1)) do
      expect(page).to have_content(header)
    end
  end

  [auction.title, auction.delivery_due_at, auction.delivery_url,
   auction.winning_bidder.name, auction.rejected_at].each_with_index do |expected, i|
    within(:xpath, cel_xpath(table_id: 'table-rejected', column: i + 1)) do
      expect(page).to have_content(expected)
    end
  end
end
