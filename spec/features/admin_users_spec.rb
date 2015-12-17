require 'rails_helper'

RSpec.feature "AdminUsers", type: :feature do
  before do
    create_user
    sign_in_admin
  end

  scenario "visiting the admin users list and then a user" do
    visit "/admin/users"
    expect(page).not_to have_text('must be an admin')
    user = Presenter::User.new(@user)

    expect(page).to have_text(user.duns_number)
    expect(page).to have_text(user.email)
    expect(page).to have_text(user.name)
    expect(page).to have_text(user.github_id)
  end
end
