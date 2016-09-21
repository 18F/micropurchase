When(/^I should see my user info$/) do
  user = UserPresenter.new(@user)

  expect(page).to have_text(user.email)
  expect(page).to have_text(user.name)
end

Then(/^I should see that user's information$/) do
  expect(page).to have_content(@user.name)
  expect(page).to have_content(@user.email)
  expect(page).to have_content(@user.payment_url)
  expect(page).to have_content(@user.duns_number)
  expect(page).to have_content(@user.github_id)
  expect(page).to have_content(@user.github_login)
end

Then(/^in that section I should see a table of the user's bids$/) do
  table_headers = ['Auction', 'Status', 'Skills', 'User Bids', 'User Won?', 'Accepted?']

  table_headers.each_with_index do |header, index|
    within(:xpath, th_xpath(table_id: 'bid-history', column: index + 1)) do
      expect(page).to have_content(header)
    end
  end

  view_model = Admin::UserAuctionViewModel.new(@auction, @user)

  values = [
    view_model.title,
    view_model.bidding_status,
    view_model.skills,
    view_model.user_bid_count,
    view_model.user_won_label,
    view_model.accepted_label
  ]

  values.each_with_index do |value, index|
    within(:xpath, cel_xpath(table_id: 'bid-history', column: index + 1)) do
      expect(page).to have_content(value)
    end
  end
end
