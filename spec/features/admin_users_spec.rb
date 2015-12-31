require 'rails_helper'

RSpec.feature "AdminUsers", type: :feature do
  before do
    sign_in_admin
  end

  scenario "visiting the admin users list" do
    create_user
    visit "/admin/users"
    expect(page).not_to have_text('must be an admin')
    user = Presenter::User.new(@user)

    expect(page).to have_text(user.duns_number)
    expect(page).to have_text(user.email)
    expect(page).to have_text(user.name)
    expect(page).to have_text(user.github_id)
  end

  scenario "counting the number of users and admins" do
    number_of_users = 11
    number_of_users.times { create_user }
    visit "/admin/users"
    expect(page).to have_text("Users (#{number_of_users}")
    expect(page).to have_text("Admins (1)")
  end
end
