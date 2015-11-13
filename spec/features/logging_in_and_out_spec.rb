require 'rails_helper'

RSpec.feature "logging in and out of the app", type: :feature do
  scenario "New user logs in, created and logs out via header link" do
    visit "/"

    click_on "Login"
    expect(page).to have_content("Authorize with GitHub")

    click_on("Authorize with GitHub")
    expect(page).to have_content("Doris Doogooder")
    expect(page).to have_content("Logout")

    expect(page).to have_content("Enter your DUNS number")
    fill_in("user_duns_number", with: "123-duns")
    click_on('Submit')

    expect(page.current_path).to eq("/")

    click_on("Logout")
    expect(page).not_to have_content("Doris Doogooder")
    expect(page).to have_content("Login")
  end

  scenario "Existing user logs in via header" do
    visit "/"

    create_authed_bidder

    click_on "Login"
    expect(page).to have_content("Authorize with GitHub")

    click_on("Authorize with GitHub")
    expect(page).to have_content("Doris Doogooder")
    expect(page).to have_content("Logout")

    # another bad UX, users have to see this entry point regardless of whether they have a duns number
    expect(page).to have_content("Enter your DUNS number")
    expect(page.find('#user_duns_number').value).to eq('DUNS-123')
  end

  scenario "User logs in when viewing protected or specific information" do
    visit "/my-bids"

    expect(page).to have_content("Authorize with GitHub")

    click_on("Authorize with GitHub")
    expect(page).to have_content("Doris Doogooder")
    expect(page).to have_content("Logout")
  end
end
