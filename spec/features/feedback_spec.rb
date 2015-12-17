require 'rails_helper'

RSpec.feature "User is given opportunities to provide feedback", type: :feature do
  scenario "Viewing the home page" do
    visit "/"
    expect(page).to have_content("Submit Feedback")
  end
end
