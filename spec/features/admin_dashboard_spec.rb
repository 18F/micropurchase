require 'rails_helper'

RSpec.feature "AdminDashboards", type: :feature do
  before do
    @complete_and_successful = 5.times.map do
      FactoryGirl.create(:auction, :complete_and_successful)
    end
    sign_in_admin
  end

  scenario "Viewing the action items dashboard" do
    visit "/admin/action_items"

    @complete_and_successful.each do |auction|
      expect(page).to have_text(auction.title)
    end
  end

end
