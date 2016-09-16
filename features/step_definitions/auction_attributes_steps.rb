Then(/^I should see the auction$/) do
  expect(page).to have_text(@auction.title)
  expect(page).to have_text(@auction.sorted_skill_names.join(', '))
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

Then(/^I should see the skills required for the auction$/) do
  within('.auction-description') do
    expect(page).to have_content(@auction.sorted_skill_names.to_sentence)
  end
end

Then(/^I should see that the auction has a C2 Proposal URL$/) do
  expect(@auction.reload.c2_proposal_url).to be_present
  within(:css, '.auction-info') do
    expect(page).to have_content(@auction.c2_proposal_url)
  end
end

Then(/^I should see that the auction does not have a C2 Proposal URL$/) do
  expect(@auction.c2_proposal_url).not_to be_present
end

Then(/^I should see when bidding starts and ends in ET$/) do
  expect(page).to have_text(DcTimePresenter.convert_and_format(@auction.started_at))
  expect(page).to have_text(DcTimePresenter.convert_and_format(@auction.ended_at))
end

Then(/^I should see the delivery_due_at timestamp in ET$/) do
  expect(page).to have_text(DcTimePresenter.convert_and_format(@auction.delivery_due_at))
end

Then(/^I should see when the winning vendor was paid in ET$/) do
  @auction.reload
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
  expect(@auction.reload).to be_accepted
  expect(page).to have_content(
    DcTimePresenter.convert_and_format(@auction.accepted_at)
  )
end

Then(/^I should see that the auction was not accepted$/) do
  expect(page).not_to have_content("Accepted at")
  expect(@auction.reload.accepted_at).to eq nil
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

Then(/^I should see the name of the auction$/) do
  expect(page).to have_text(@auction.title)
end

Then(/^I should see the edit link for the auction$/) do
  expect(page).to have_link('edit', href: edit_admin_auction_path(@auction.id))
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
