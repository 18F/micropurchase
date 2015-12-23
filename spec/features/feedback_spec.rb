require 'rails_helper'

RSpec.feature "User is given opportunities to provide feedback", type: :feature do
  scenario "Viewing the home page" do
    visit "/"
    expect(page).to have_content("Give Feedback")
    expect(page).to have_content("Get In Touch")
    expect(page).to have_content("View Our Code on GitHub")
  end
end
