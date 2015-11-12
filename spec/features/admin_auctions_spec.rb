require 'rails_helper'

RSpec.feature "AdminAuctions", type: :feature do
  before do
    create_current_auction
    sign_in_admin
  end

  scenario "visiting the admin auctions list and then an auction" do
    visit "/admin/auctions"
    expect(page).not_to have_text('must be an admin')
    expect(page).to have_text(@auction.title)
    click_on(@auction.title)
    expect(page).to have_text('$1,000')
    expect(page).to have_text(@auction.description)
  end

  scenario "adding an auction" do
    visit "/admin/auctions"
    expect(page).not_to have_text('must be an admin')
    find('a.usa-button-green').click

    title = 'Build the micropurchase thing'
    fill_in("auction_title", with: title)
    fill_in("auction_description", with: 'and the admin related stuff')
    fill_in("auction_start_datetime", with: (Time.now + 3.days).strftime("%m/%d/%Y"))
    fill_in("auction_end_datetime", with: (Time.now - 3.days).strftime("%m/%d/%Y"))
    fill_in("auction_github_repo", with: "https://github.com/18F/calc")
    fill_in("auction_issue_url", with: "https://github.com/18F/calc/issues/255")
    click_on("Submit")

    expect(page).to have_text(@auction.title)
    expect(page).to have_text("Build the micropurchase thing")
    expect(page).to have_text(
      Presenter::DcTime.convert(Time.now + 3.days).beginning_of_day.to_s(:long)
    )
  end

  scenario "updating an auction" do
    visit "/admin/auctions"
    click_on("Edit")

    title = 'Build the micropurchase thing'
    fill_in("auction_title", with: title)
    fill_in("auction_description", with: 'and the admin related stuff')
    fill_in("auction_github_repo", with: "https://github.com/18F/calc")
    fill_in("auction_issue_url", with: "https://github.com/18F/calc/issues/255")
    click_on("Submit")

    expect(page).to have_text("Build the micropurchase thing")
  end
end
