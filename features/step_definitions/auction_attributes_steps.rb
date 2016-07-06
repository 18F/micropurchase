Then(/^I should see the auction$/) do
  expect(page).to have_text(@auction.title)
end

Then(/^I should see the auction's (.+)$/) do |field|
  if field == 'deadline'
    expect(page).to have_text(
      DcTimePresenter
        .convert(@auction.ended_at)
        .strftime(DcTimePresenter::FORMAT))
  else
    expect(page).to have_text(@auction.send(field))
  end
end

Then(/^I should see that the auction has a CAP Proposal URL$/) do
  expect(@auction.reload.cap_proposal_url).to be_present
  within(:css, '.auction-info') do
    expect(page).to have_content(@auction.cap_proposal_url)
  end
end

Then(/^I should see that the auction does not have a CAP Proposal URL$/) do
  expect(@auction.cap_proposal_url).not_to be_present
end

Then(/^I should see when bidding starts and ends in ET$/) do
  expect(page).to have_text(DcTimePresenter.convert_and_format(@auction.started_at))
  expect(page).to have_text(DcTimePresenter.convert_and_format(@auction.ended_at))
end

Then(/^I should see the delivery_due_at timestamp in ET$/) do
  expect(page).to have_text(DcTimePresenter.convert_and_format(@auction.delivery_due_at))
end

Then(/^I should see when the winning vendor was paid in ET$/) do
  expect(page).to have_text(DcTimePresenter.convert_and_format(@auction.paid_at))
end

Then(/^I should see when the auction started$/) do
  expect(page).to have_text(DcTimePresenter.convert_and_format(@auction.started_at))
end

Then(/^I should see when the auction ends$/) do
  expect(page).to_not have_content("Auction ended at")
  expect(page).to have_content("Bid deadline #{DcTimePresenter.convert_and_format(@auction.ended_at)}")
end

Then(/^I should see when the auction ended$/) do
  expect(page).to_not have_content("Bid deadline")
  expect(page).to have_text("Auction ended at #{DcTimePresenter.convert_and_format(@auction.ended_at)}")
end

Then(/^I should see the delivery deadline$/) do
  expect(page).to have_content("Delivery deadline #{DcTimePresenter.convert_and_format(@auction.delivery_due_at)}")
end

Then(/^I should see the start price for the auction is \$(\d+)$/) do |price|
  expect(page).to have_field('auction_start_price', with: price)
end

Then(/^I should see that the auction was accepted$/) do
  expect(@auction.accepted_at).not_to eq nil
  expect(page).to have_content(
    DcTimePresenter.convert_and_format(@auction.accepted_at)
  )
end

Then(/^I should see the number of bid for the auction$/) do
  number_of_bids = "#{@auction.bids.length} bids"
  expect(page).to have_content(number_of_bids)
end

Then(/^I should not see the number of bid for the auction$/) do
  number_of_bids = "#{@auction.bids.length} bids"
  expect(page).to_not have_content(number_of_bids)
end

Then(/^I should see that the auction indicates it is for small business only$/) do
  auction_div = find('a', text: @auction.title)
                .find(:xpath, "..")
                .find(:xpath, "..")
                .find(:xpath, "..")

  expect(auction_div).to have_content('Small-business only')
end

Then(/^I should not see that the auction indicates it is for small business only$/) do
  auction_div = find('a', text: @auction.title)
                .find(:xpath, "..")
                .find(:xpath, "..")
                .find(:xpath, "..")

  expect(auction_div).to_not have_content('Small-business only')
end

Then(/^I should see a preview of the auction$/) do
  expect(page).to have_text(@unpublished_auction.description)
end

Then(/^I should see the name of each dashboard auction$/) do
  @complete_and_successful.each do |auction|
    expect(page).to have_text(auction.title)
  end
end

Then(/^I should see edit links for each dashboard auction$/) do
  @complete_and_successful.each do |auction|
    expect(page).to have_link('edit', href: edit_admin_auction_path(auction.id))
  end
end

Then(/^I should not see the unpublished auction$/) do
  expect(page).to_not have_content(@unpublished_auction.title)
end

Then(/^I should be able to set the auction to published$/) do
  expect(page).to have_select('auction_published', with_options: ['published'])
end

Then(/^I should not be able to set the auction to published$/) do
  expect(page).not_to have_select('auction_published', options: ['published'])
end
