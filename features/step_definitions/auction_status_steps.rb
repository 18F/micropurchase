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

def end_date
  DcTimePresenter.convert_and_format(@auction.ended_at)
end
