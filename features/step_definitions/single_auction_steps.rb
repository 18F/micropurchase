Then(/^I expect to not see bids from other users$/) do
  @auction.bids.each do |bid|
    next if bid.bidder_id == @user.id
    amount = ApplicationController.helpers.number_to_currency(bid.amount)
    expect(page).to_not have_content(amount)
  end
end

