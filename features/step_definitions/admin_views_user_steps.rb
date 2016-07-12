Then(/^in that section I should see a table of the user's bids$/) do
  table_headers = ['Auction', 'Status', 'Skills', 'User Bids', 'User Won?', 'Accepted?']

  table_headers.each_with_index do |header, index|
    within(:xpath, th_xpath(table_id: 'bidding-history', column: index+1)) do
      expect(page).to have_content(header)
    end
  end

  view_model = Admin::UserAuctionViewModel.new(@auction, @user)

  values = [view_model.title, view_model.status, view_model.skills, view_model.user_bid_count, view_model.user_won_label, view_model.accepted_label]

  values.each_with_index do |value, index|
    within(:xpath, cel_xpath(table_id: 'bidding-history', column: index+1)) do
      expect(page).to have_content(value)
    end
  end
end
