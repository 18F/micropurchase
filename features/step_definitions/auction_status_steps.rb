Then(/^I should the open auction message for guests$/) do
  expect(page).to have_content(
    "This auction is accepting bids until #{end_date}. Sign in or sign up with GitHub to bid."
  )
end

Then(/^I should the open auction message for admins$/) do
  expect(page).to have_content(
    "This auction is accepting bids until #{end_date}."
  )
end

Then(/^I should see the time I placed my bid$/) do
  bid = @auction.bids.last

  expect(page).to have_content(
    "You bid #{Currency.new(bid.amount)} on #{DcTimePresenter.convert_and_format(bid.created_at)}."
  )
end

def end_date
  DcTimePresenter.convert_and_format(@auction.ended_at)
end
