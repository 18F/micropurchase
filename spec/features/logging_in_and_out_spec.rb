require 'rails_helper'

RSpec.feature "logging in and out of the app", type: :feature do
  scenario "User logs in and clicks edit profile link" do
    visit "/"

    create_authed_bidder

    find('.button-login').click

    expect(page).to have_content("Authorize with GitHub")

    click_on("Authorize with GitHub")

    expect(page).to have_content("Edit profile")
    click_on("Edit profile")

    expect(page).to have_content("Complete your account")
    expect(page).to have_content("Name")
    expect(page).to have_content("DUNS Number")
    expect(page).to have_content("Email Address")
  end

  scenario "New user logs in, created and logs out via header link" do
    visit "/"

    find('.button-login').click
    expect(page).to have_content("Authorize with GitHub")

    click_on("Authorize with GitHub")
    expect(page).to have_content("Doris Doogooder")
    expect(page).to have_content("Logout")

    new_name = Faker::Name.name
    expect(page).to have_content("Enter your DUNS number")
    fill_in("user_name", with: new_name)
    fill_in("user_duns_number", with: "123-duns")
    fill_in("user_email", with: "doris@doogooder.io")
    click_on('Submit')

    expect(page.current_path).to eq("/")

    click_on("Logout")
    expect(page).not_to have_content(new_name)
    expect(page).to have_content("Login")
  end

  scenario "Existing user logs in via header" do
    visit "/"

    create_authed_bidder

    find('.button-login').click
    expect(page).to have_content("Authorize with GitHub")

    click_on("Authorize with GitHub")
    expect(page).to have_content("Doris Doogooder")
    expect(page).to have_content("Logout")

    # another bad UX, users have to see this entry point regardless of whether they have a duns number
    expect(page).to have_content("Enter your DUNS number")
    expect(page.find('#user_duns_number').value).to eq(@bidder.duns_number)
  end

  scenario "User logs in when viewing protected or specific information" do
    visit "/my-bids"

    expect(page).to have_content("Authorize with GitHub")

    click_on("Authorize with GitHub")
    expect(page).to have_content('Doris Doogooder')
    expect(page).to have_content("Logout")
  end

  scenario "User views and edits their information" do
    visit "/"

    create_authed_bidder

    find('.button-login').click
    expect(page).to have_content("Authorize with GitHub")

    click_on("Authorize with GitHub")
    visit edit_user_path @bidder

    email_field = find_field("Email Address")
    duns_field = find_field("DUNS Number")

    expect(email_field.value).to eq(@bidder.email)
    expect(duns_field.value).to eq(@bidder.duns_number)

    fill_in("Email Address", with: "doris@doogooder.com")
    click_on('Submit')

    visit edit_user_path @bidder
    expect(email_field.value).to eq("doris@doogooder.com")
  end

  scenario "User tries to enter an invalid email address" do
    visit "/"

    create_authed_bidder

    find('.button-login').click
    expect(page).to have_content("Authorize with GitHub")

    click_on("Authorize with GitHub")
    visit edit_user_path @bidder

    email_field = find_field("Email Address")
    duns_field = find_field("DUNS Number")

    expect(email_field.value).to eq(@bidder.email)
    expect(duns_field.value).to eq(@bidder.duns_number)

    fill_in("Email Address", with: "doris_the_nonvalid_email_address_person")
    click_on('Submit')

    expect(page).to have_content("Email is invalid")
    expect(page).to have_css("div.usa-alert.usa-alert-error")
  end
end
