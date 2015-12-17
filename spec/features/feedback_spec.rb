require 'rails_helper'

RSpec.feature "User is given opportunities to provide feedback", type: :feature do
  scenario "Viewing the home page" do
    visit "/"
    expect(page).to have_content("Submit Feedback")
    expect(page).to have_content("Email Us")
    expect(page).to have_content("18F Homepage")
    expect(page).to have_content("See This Project on GitHub")
  end
end
