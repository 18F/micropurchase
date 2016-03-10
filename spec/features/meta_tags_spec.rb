require 'rails_helper'
require 'action_view'

# rubocop:disable Metrics/LineLength
RSpec.feature "Pages have meta tags", type: :feature do
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::NumberHelper

  scenario 'Main page meta tags' do
    create_closed_and_current_auctions
    @auction = FactoryGirl.create(:auction, :future)

    visit "/"

    expect(page).to have_css("title", visible: false, text: "18F - Micro-purchase")
    expect(page).to have_css("meta[property='og:title'][content='18F - Micro-purchase']", visible: false)
    expect(page).to have_css("meta[name='description'][content='The Micro-purchase Marketplace is the place to bid on open-source issues from the 18F team.']", visible: false)
    expect(page).to have_css("meta[property='og:description'][content='The Micro-purchase Marketplace is the place to bid on open-source issues from the 18F team.']", visible: false)
    expect(page).to have_css("meta[name='twitter:label1'][value='Active Auctions']", visible: false)
    expect(page).to have_css("meta[name='twitter:data1'][value='5']", visible: false)
    expect(page).to have_css("meta[name='twitter:label2'][value='Coming Auctions']", visible: false)
    expect(page).to have_css("meta[name='twitter:data2'][value='1']", visible: false)
  end

  scenario "Open auction meta tags" do
    skip 'removing meta tags for now'
    current_auction, _bids = create_current_auction
    visit auction_path(current_auction)

    @auction = Presenter::Auction.new(@auction)

    expect(page).to have_css("title", visible: false, text: "18F Micro-purchase - #{@auction.title}")
    expect(page).to have_css("meta[property='og:title'][content='18F Micro-purchase - #{@auction.title}']", visible: false)
    expect(page).to have_css("meta[name='description'][content='#{@auction.summary}']", visible: false)
    expect(page).to have_css("meta[property='og:description'][content='#{@auction.summary}']", visible: false)
  end

  scenario "Closed auction meta tags" do
    skip 'removing meta tags for now'

    closed_auction, _bids = create_closed_auction
    visit auction_path(closed_auction)

    @auction = Presenter::Auction.new(@auction)

    expect(page).to have_css("title", visible: false, text: "18F Micro-purchase - #{@auction.title}")
    expect(page).to have_css("meta[property='og:title'][content='18F Micro-purchase - #{@auction.title}']", visible: false)
    expect(page).to have_css("meta[name='description'][content='#{@auction.summary}']", visible: false)
    expect(page).to have_css("meta[property='og:description'][content='#{@auction.summary}']", visible: false)
  end

  scenario "Edit profile meta tags" do
    visit "/"

    create_authed_bidder

    find('.button-login').click
    click_on("Authorize with GitHub")
    click_on("Edit profile")

    expect(page).to have_css("title", visible: false, text: "18F Micro-purchase - Edit user: Doris Doogooder")
  end
end
# rubocop:enable Metrics/LineLength
