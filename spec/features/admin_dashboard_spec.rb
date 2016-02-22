require 'rails_helper'

RSpec.feature "AdminDashboards", type: :feature do
  before do
    @complete_and_successful = Array.new(5) do
      FactoryGirl.create(:auction, :complete_and_successful)
    end
    @unpublished = FactoryGirl.create(:auction, :unpublished)
    sign_in_admin
  end

  scenario "Viewing the action items dashboard" do
    visit "/admin/action_items"

    @complete_and_successful.each do |auction|
      expect(page).to have_text(auction.title)
    end
  end

  scenario "Viewing a preview of an unpublished auction" do
    visit "/admin/auctions/#{@unpublished.id}/preview"

    expect(page).to have_text(@unpublished.description)
  end
end
