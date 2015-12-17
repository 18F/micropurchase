require 'rails_helper'

RSpec.feature "bidder interacts with auction", type: :feature do
  scenario "Viewing auction list and navigating to bid history" do
    create_current_auction

    visit "/"

    number_of_bids = "#{@auction.bids.length} bids"
    expect(page).to have_content(number_of_bids)

    click_on(number_of_bids)

    h1_text = "Bids for \"#{@auction.title}\""
    expect(page).to have_content(h1_text)
  end

  scenario "Viewing an open auction" do
    current_auction, _bids = create_current_auction
    visit auction_path(current_auction)

    expect(page).to have_content("Open")
  end

  scenario "Viewing a closed auction" do
    closed_auction, _bids = create_closed_auction
    visit auction_path(closed_auction)

    expect(page).to have_content("Closed")
  end

  scenario "Viewing auction detail page and navigating to bid history" do
    create_current_auction

    visit auction_path(@auction.id)

    number_of_bids = "#{@auction.bids.length} bids"
    expect(page).to have_content(number_of_bids)

    click_on(number_of_bids)

    h1_text = "Bids for \"#{@auction.title}\""
    expect(page).to have_content(h1_text)
  end

  scenario "Viewing auction list and detail view as a logged out user" do
    create_current_auction

    # seeing auction list
    visit "/"
    expect(page).to have_content(@auction.title)
    expect(page).to have_content("Current Bid:")

    # going to the auction detail page
    click_on(@auction.title)
    page.find("a[href='#{@auction.issue_url}']")

    # going via another link
    visit "/"
    click_on("View details »")
    page.find("a[href='#{@auction.issue_url}']")

    # logging in via bid click
    click_on("Bid »")
    expect(page).to have_content("Authorize with GitHub")
    click_on("Authorize with GitHub")
    # completing user profile
    fill_in("user_duns_number", with: "123-duns")
    click_on('Submit')

    # bad ui brings us back to the home page :(
    click_on("Bid »")
    expect(page).to have_content("Current bid:")

    # fill in the form
    fill_in("bid_amount", with: '800')
    click_on("Submit")

    # returns us back to the bid page
    expect(page).to have_content("Current Bid:")
    expect(page).to have_content("$800.00")
  end

  scenario "Bidding on an auction when logged in" do
    create_current_auction

    visit "/"
    sign_in_bidder

    click_on("Bid »")
    expect(page).not_to have_content("Authorize with GitHub")
    expect(page).to have_content("Current bid:")

    fill_in("bid_amount", with: '999')
    click_on("Submit")

    # returns us back to the bid page
    expect(page).to have_content("Current Bid:")
    expect(page).to have_content("$999.00")
    expect(page).to have_content("You currently have the winning bid.")
  end



  scenario "Is not the current winning bidder with no bids" do
    create_bidless_auction

    visit "/"
    sign_in_bidder

    click_on("Bid »")
    expect(page).not_to have_content("Authorize with GitHub")
    expect(page).to have_content("Current bid:")
    expect(page).to have_content("No bids yet.")
    expect(page).not_to have_content("You are currently the winning bidder.")

    fill_in("bid_amount", with: '999')
    click_on("Submit")
  end

  scenario "Is not the current winning bidder with bids from other users" do
    create_current_auction

    visit "/"
    sign_in_bidder

    click_on("Bid »")

    expect(page).not_to have_content("Authorize with GitHub")
    expect(page).to have_content("Current bid:")
    expect(page).not_to have_content("You are currently the winning bidder.")
    expect(page).to have_content("You are currently not the winning bidder.")
  end

  scenario "Bidding on a bid-less auction while logged in" do
    create_bidless_auction

    visit "/"
    sign_in_bidder

    click_on("Bid »")
    expect(page).not_to have_content("Authorize with GitHub")
    expect(page).to have_content("Current bid:")
    expect(page).to have_content("No bids yet.")
  end

  scenario "Viewing bid history for running auction" do
    Timecop.scale(36000) do
      create_running_auction
    end
    path = auction_bids_path(@auction.id)
    visit path

    # sort the bids so that newest is first
    bids = @auction.bids.sort_by {|bid| bid.created_at}.reverse

    # ensure the table has the correct content, in the correct order
    bids.each_with_index do |bid, i|
      row_number = i + 1
      unredacted_bidder_name = bid.bidder.name
      bid = Presenter::Bid.new(bid)

      # check the "name" column
      within(:xpath, cel_xpath(row_number, 1)) do
        expect(page).not_to have_content(unredacted_bidder_name)
        expect(page).to have_content("[Name witheld until the auction ends]")
      end

      # check the "amount" column
      amount = ApplicationController.helpers.number_to_currency(bid.amount)
      within(:xpath, cel_xpath(row_number, 2)) do
        expect(page).to have_content(amount)
      end

      # check the "date" column
      within(:xpath, cel_xpath(row_number, 3)) do
        expect(page).to have_content(bid.time)
      end

    end
  end

  scenario "Viewing auction page for a closed auction" do
    create_closed_auction
    auction = Presenter::Auction.new(@auction)
    visit auction_bids_path(auction.id)

    expect(page).to have_content("Winning Bid (#{auction.current_bidder.name}):")
    expect(page).not_to have_content("Current Bid:")

    expect(page).to have_content("Auction ended at:")
    expect(page).not_to have_content("Bid deadline:")
  end

  scenario "Viewing auction page for a closed auction with no bidders" do
    create_closed_bidless_auction
    auction = Presenter::Auction.new(@auction)
    visit auction_bids_path(auction.id)

    expect(page).to have_content("Auction ended with no bids.")
    expect(page).not_to have_content("Current Bid:")

    expect(page).to have_content("Auction ended at:")
    expect(page).not_to have_content("Bid deadline:")
  end


  scenario "Viewing bid history for a closed auction" do
    Timecop.scale(36000) do
      create_closed_auction
    end
    path = auction_bids_path(@auction.id)
    visit path

    # sort the bids so that newest is first
    bids = @auction.bids.sort_by {|bid| bid.created_at}.reverse

    # ensure the table has the correct content, in the correct order
    bids.each_with_index do |bid, i|
      row_number = i + 1
      unredacted_bidder_name = bid.bidder.name
      bid = Presenter::Bid.new(bid)

      # check the "name" column
      within(:xpath, cel_xpath(row_number, 1)) do
        expect(page).to have_content(unredacted_bidder_name)
      end

      # check the "amount" column
      if i == 0
        # ensure the first row bid amount includes an asterisk
        amount = ApplicationController.helpers.number_to_currency(bid.amount)
        within(:xpath, cel_xpath(row_number, 2)) do
          expect(page).to have_content("#{amount} *")
        end
      else
        amount = ApplicationController.helpers.number_to_currency(bid.amount)
        within(:xpath, cel_xpath(row_number, 2)) do
          expect(page).to have_content(amount)
          expect(page).not_to have_content("#{amount} *")
        end
      end

      # check the "date" column
      within(:xpath, cel_xpath(row_number, 3)) do
        expect(page).to have_content(bid.time)
      end

    end
  end
end
