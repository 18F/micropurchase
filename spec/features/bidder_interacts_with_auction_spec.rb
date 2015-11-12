require 'rails_helper'

RSpec.feature "bidder interacts with auction", type: :feature do
  scenario "Viewing auction list and detail view as a logged out user" do
    create_current_auction

    # seeing auction list
    visit "/"
    expect(page).to have_content(@auction.title)
    expect(page).to have_content("Current Bid:")

    # going to the auction detail page
    click_on(@auction.title)
    page.find("a[href='#{@auction.issue_url}']")

    # going via another link
    visit "/"
    click_on("Details »")
    page.find("a[href='#{@auction.issue_url}']")

    # logging in via bid click
    click_on("Bid »")
    expect(page).to have_content("Authorize with GitHub")
    click_on("Authorize with GitHub")
    # completing user profile
    fill_in("user_duns_number", with: "123-duns")
    click_on('Submit')

    # bad ui brings us back to the home page :(
    click_on("Bid »")
    expect(page).to have_content("Current bid:")

    # fill in the form
    fill_in("bid_amount", with: '800')
    click_on("Submit")

    # returns us back to the bid page
    expect(page).to have_content("Current bid:")
    expect(page).to have_content("$800.00")
  end

  scenario "Bidding on an auction when logged in" do
    create_current_auction

    visit "/"
    sign_in_bidder

    click_on("Bid »")
    expect(page).not_to have_content("Authorize with GitHub")
    expect(page).to have_content("Current bid:")

    fill_in("bid_amount", with: '999')
    click_on("Submit")

    # returns us back to the bid page
    expect(page).to have_content("Current bid:")
    expect(page).to have_content("$999.00")
  end
end
