# coding: utf-8
require 'rails_helper'

RSpec.feature "bidder interacts with auction", type: :feature do
  context 'viewing the auctions index page' do
    scenario "There are no auctions" do
      visit "/"

      expect(page).to have_content("There are no current open auctions on the site. " \
                                 "Please check back soon to view micropurchase opportunities.")
    end

    scenario "Viewing auction list and navigating to bid history" do
      @auction = FactoryGirl.create(:auction, :with_bidders)

      visit "/"

      number_of_bids = "#{@auction.bids.length} bids"
      expect(page).to have_content(number_of_bids)
      expect(page).to have_content(@auction.summary)

      click_on(number_of_bids)

      h1_text = "Bids for \"#{@auction.title}\""
      expect(page).to have_content(h1_text)
    end

    scenario "There is a closed auction" do
      @auction = FactoryGirl.create(:auction, :closed)

      visit '/'

      within(:css, 'div.issue-list-item') do
        within(:css, 'span.usa-label-big') do
          expect(page).to have_content('Closed')
        end
      end

      expect(page).to_not have_content('Bid »')
    end

    scenario "There is an expiring auction" do
      @auction = FactoryGirl.create(:auction, :expiring)

      visit '/'

      within(:css, 'div.issue-list-item') do
        within(:css, 'span.usa-label-big') do
          expect(page).to have_content('Expiring')
        end
      end

      expect(page).to have_content('Bid »')
    end

    scenario "There is a future auction" do
      @auction = FactoryGirl.create(:auction, :future)

      visit '/'

      within(:css, 'div.issue-list-item') do
        within(:css, 'span.usa-label-big') do
          expect(page).to have_content('Coming Soon')
        end
      end

      expect(page).to_not have_content('Bid »')
    end

    scenario "There are several auctions" do
      # Test ordering here
    end
  end

  context "an auction's page" do
    scenario "Viewing an open auction" do
      current_auction, _bids = create_current_auction
      visit auction_path(current_auction)

      expect(page).to have_content("Open")
      expect(page).to have_content(current_auction.end_datetime.strftime('%m/%d/%Y at %I:%M %p %Z'))
      expect(page).to have_content(current_auction.start_datetime.strftime('%m/%d/%Y at %I:%M %p %Z'))
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
  end

  scenario "Viewing auction list and detail view as a logged out user" do
    create_current_auction

    # seeing auction list
    visit "/"
    expect(page).to have_content(@auction.title)
    expect(page).to have_content("Current bid:")

    # going to the auction detail page
    click_on(@auction.title)
    page.find("a[href='#{@auction.issue_url}']")

    # going via another link
    visit "/"
    click_on("View details »")
    page.find("a[href='#{@auction.issue_url}']")

    # logging in via bid click
    click_on("BID")
    @bidder = create_authed_bidder
    expect(page).to have_content("Authorize with GitHub")
    click_on("Authorize with GitHub")
    click_on('Submit')

    # bad ui brings us back to the home page :(
    click_on("Bid »")
    expect(page).to have_content("Current bid:")

    # fill in the form
    fill_in("bid_amount", with: '800')
    click_on("Submit")

    # returns us back to the bid page
    expect(page).to have_content("Current bid:")
    expect(page).to have_content("$800.00")
  end

  context "placing bids" do
    scenario "Viewing auction list and detail view as a logged out user" do
      create_current_auction
      @bidder = create_authed_bidder
      # seeing auction list
      visit "/"
      expect(page).to have_content(@auction.title)
      expect(page).to have_content("Current bid:")

      # going to the auction detail page
      click_on(@auction.title)
      page.find("a[href='#{@auction.issue_url}']")

      # going via another link
      visit "/"
      click_on("View details »")
      page.find("a[href='#{@auction.issue_url}']")

      # logging in via bid click
      click_on("BID")
      expect(page).to have_content("Authorize with GitHub")
      click_on("Authorize with GitHub")
      # completing user profile
      click_on('Submit')

      # bad ui brings us back to the home page :(
      click_on("Bid »")
      expect(page).to have_content("Current bid:")

      # fill in the form
      fill_in("bid_amount", with: '800')
      click_on("Submit")

      # returns us back to the bid page
      expect(page).to have_content("Current bid:")
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
      expect(page).to have_content("Current bid:")
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
  end

  context "when a user's DUNS is not registered in SAM" do
    scenario "Viewing the auctions index page" do
      create_current_auction

      @bidder = create_authed_bidder
      @bidder.update_attributes(sam_account: false)
      visit '/'

      click_on "Login"
      click_on("Authorize with GitHub")

      click_on('Submit')

      expect(page).to_not have_content("Bid »")
      expect(page).to have_content('Your DUNS is not registered with SAM')

      expect(page).to have_link('SAM.gov', href: 'https://www.sam.gov/')
      expect(page).to have_link('the SAM.gov status checker', href: 'https://www.sam.gov/sam/helpPage/SAM_Reg_Status_Help_Page.html')
      expect(page).to have_link('entered your DUNS number into your profile', href: edit_user_path(@bidder))
    end

    scenario "Viewing the auction detail page" do
      create_current_auction

      visit '/'
      sign_in_bidder
      @bidder.update_attributes(sam_account: false)

      visit auction_path(@auction)
      expect(page).to_not have_content("Bid »")
      expect(page).to have_content('Your DUNS is not registered with SAM')

      expect(page).to have_link('SAM.gov', href: 'https://www.sam.gov/')
      expect(page).to have_link('the SAM.gov status checker', href: 'https://www.sam.gov/sam/helpPage/SAM_Reg_Status_Help_Page.html')
      expect(page).to have_link('entered your DUNS number into your profile', href: edit_user_path(@bidder))
    end
  end

  scenario "Viewing bid history for running auction" do
    Timecop.scale(3_600) do
      create_current_auction
    end
    path = auction_bids_path(@auction.id)
    visit path

    # sort the bids so that newest is first
    bids = @auction.bids.sort_by(&:created_at).reverse

    # ensure the table has the correct content, in the correct order
    bids.each_with_index do |bid, i|
      row_number = i + 1
      unredacted_bidder_name = bid.bidder.name
      unredacted_bidder_duns = bid.bidder.duns_number
      bid = Presenter::Bid.new(bid)

      # check the "name" column
      within(:xpath, cel_xpath(row_number, 1)) do
        expect(page).not_to have_content(unredacted_bidder_name)
        expect(page).to have_content("[Name withheld until the auction ends]")
      end

      within(:xpath, cel_xpath(row_number, 2)) do
        expect(page).not_to have_content(unredacted_bidder_duns)
        expect(page).to have_content("[Withheld]")
      end

      # check the "amount" column
      amount = ApplicationController.helpers.number_to_currency(bid.amount)
      within(:xpath, cel_xpath(row_number, 3)) do
        expect(page).to have_content(amount)
      end

      # check the "date" column
      within(:xpath, cel_xpath(row_number, 4)) do
        expect(page).to have_content(bid.time)
      end
    end
  end

  context "an individual auction page" do
    scenario "Viewing auction page for a closed auction where a user is not authenticated" do
      create_closed_auction
      auction = Presenter::Auction.new(@auction)
      visit auction_path(auction.id)

      expect(page).to have_css('.usa-alert-info')
      expect(page).to have_css('.auction-alert')
      expect(page).to have_content("Winning bid (#{auction.current_bidder_name}):")
      expect(page).not_to have_content("Current bid:")

      expect(page).to have_content("Auction ended at:")
      expect(page).not_to have_content("Bid deadline:")
    end

    scenario "Viewing auction page for a closed auction where authenticated user is the winner" do
      create_closed_auction

      visit "/"
      sign_in_bidder

      bid = nil
      Timecop.freeze(@auction.end_datetime) do
        bid = @auction.bids.create(bidder_id: @bidder.id, amount: 1)
      end
      expect(bid).to be_valid
      @auction.reload

      auction = Presenter::Auction.new(@auction)

      expect(auction.current_bidder_name).to eq(@bidder.name)
      visit auction_path(auction.id)

      expect(page).to have_css('.usa-alert-success')
      expect(page).to have_content("You are the winner")
      expect(page).to have_content("Winning bid (#{auction.current_bidder_name}):")
      expect(page).not_to have_content("Current bid:")

      expect(page).to have_content("Auction ended at:")
      expect(page).not_to have_content("Bid deadline:")
    end

    scenario "Viewing auction page for a closed auction where authenticated user is not the winner" do
      create_closed_auction

      visit '/'
      sign_in_bidder

      auction = Presenter::Auction.new(@auction)

      bid = nil
      Timecop.freeze(@auction.start_datetime) do
        bid = @auction.bids.create(bidder_id: @bidder.id, amount: 3498)
      end
      expect(bid).to be_valid
      visit auction_path(auction.id)

      expect(page).to have_css('.usa-alert-error')
      expect(page).to have_content("You are not the winner")
      expect(page).to have_content("Winning bid (#{auction.current_bidder_name}):")
      expect(page).not_to have_content("Current bid:")

      expect(page).to have_content("Auction ended at:")
      expect(page).not_to have_content("Bid deadline:")
    end

    scenario "Viewing auction page for a closed auction where authenticated user has not placed bids" do
      create_closed_auction
      auction = Presenter::Auction.new(@auction)

      visit '/'
      sign_in_bidder

      visit auction_path(auction.id)

      expect(page).to_not have_css('.usa-alert-error')
      expect(page).to_not have_content("You are not the winner")
      expect(page).to have_content("Winning bid (#{auction.current_bidder_name}):")
      expect(page).not_to have_content("Current bid:")

      expect(page).to have_content("Auction ended at:")
      expect(page).not_to have_content("Bid deadline:")
    end

    scenario "Viewing auction page for a closed auction with no bidders" do
      create_closed_bidless_auction
      auction = Presenter::Auction.new(@auction)
      visit auction_path(auction.id)

      expect(page).to have_content("This auction ended with no bids.")
      expect(page).to have_content("Current bid:")

      expect(page).to have_content("Auction ended at:")
      expect(page).not_to have_content("Bid deadline:")
    end
  end

  context "an auction's bid history" do
    scenario "Viewing bid history for a closed auction" do
      create_closed_auction
      path = auction_bids_path(@auction.id)
      visit path

      # sort the bids so that newest is first
      bids = @auction.bids.sort_by(&:created_at).reverse

      # ensure the table has the correct content, in the correct order
      bids.each_with_index do |bid, i|
        row_number = i + 1
        unredacted_bidder_name = bid.bidder.name
        unredacted_bidder_duns = bid.bidder.duns_number
        bid = Presenter::Bid.new(bid)

        # check the "name" column
        within(:xpath, cel_xpath(row_number, 1)) do
          expect(page).to have_content(unredacted_bidder_name)
        end

        within(:xpath, cel_xpath(row_number, 2)) do
          expect(page).to have_content(unredacted_bidder_duns)
        end

        # check the "amount" column
        if i == 0
          # ensure the first row bid amount includes an asterisk
          amount = ApplicationController.helpers.number_to_currency(bid.amount)
          within(:xpath, cel_xpath(row_number, 3)) do
            expect(page).to have_content("#{amount} *")
          end
        else
          amount = ApplicationController.helpers.number_to_currency(bid.amount)
          within(:xpath, cel_xpath(row_number, 3)) do
            expect(page).to have_content(amount)
            expect(page).not_to have_content("#{amount} *")
          end
        end

        # check the "date" column
        within(:xpath, cel_xpath(row_number, 4)) do
          expect(page).to have_content(bid.time)
        end
      end
    end

    scenario 'Viewing bid history for an open auction' do
      # auction with the current logged in bidder
      auction = FactoryGirl.create(:auction, :with_bidders)

      path = auction_bids_path(auction.id)
      visit path

      # sort the bids so that newest is first
      bids = auction.bids.sort_by(&:created_at).reverse

      # ensure the table has the correct content, in the correct order
      bids.each_with_index do |bid, i|
        row_number = i + 1
        bidder_name = '[Name withheld until the auction ends]'
        bidder_duns = '[Withheld]'
        bid = Presenter::Bid.new(bid)

        # check the "name" column
        within(:xpath, cel_xpath(row_number, 1)) do
          expect(page).to have_content(bidder_name)
        end

        within(:xpath, cel_xpath(row_number, 2)) do
          expect(page).to have_content(bidder_duns)
        end

        # check the "amount" column
        if i == 0
          # ensure the first row bid amount includes an asterisk
          amount = ApplicationController.helpers.number_to_currency(bid.amount)
          within(:xpath, cel_xpath(row_number, 3)) do
            expect(page).to have_content("#{amount} *")
          end
        else
          amount = ApplicationController.helpers.number_to_currency(bid.amount)
          within(:xpath, cel_xpath(row_number, 3)) do
            expect(page).to have_content(amount)
            expect(page).not_to have_content("#{amount} *")
          end
        end

        # check the "date" column
        within(:xpath, cel_xpath(row_number, 4)) do
          expect(page).to have_content(bid.time)
        end
      end
    end

    scenario 'Viewing bid history for an open auction where the current user has bid' do
      visit '/'
      sign_in_bidder

      # auction with the current logged in bidder
      auction = FactoryGirl.create(:auction, :with_bidders)

      # sort the bids so that newest is first
      bids = auction.bids.sort_by(&:created_at).reverse
      b = bids.first
      b.update_attribute(:bidder_id, @bidder.id)

      path = auction_bids_path(auction.id)
      visit path

      # ensure the table has the correct content, in the correct order
      bids.each_with_index do |bid, i|
        row_number = i + 1

        if bid.bidder == @bidder
          bidder_name = bid.bidder.name
          bidder_duns = bid.bidder.duns_number
        else
          bidder_name = '[Name withheld until the auction ends]'
          bidder_duns = '[Withheld]'
        end

        bid = Presenter::Bid.new(bid)

        # check the "name" column
        within(:xpath, cel_xpath(row_number, 1)) do
          expect(page).to have_content(bidder_name)
        end

        within(:xpath, cel_xpath(row_number, 2)) do
          expect(page).to have_content(bidder_duns)
        end

        # check the "amount" column
        if i == 0
          # ensure the first row bid amount includes an asterisk
          amount = ApplicationController.helpers.number_to_currency(bid.amount)
          within(:xpath, cel_xpath(row_number, 3)) do
            expect(page).to have_content("#{amount} *")
          end
        else
          amount = ApplicationController.helpers.number_to_currency(bid.amount)
          within(:xpath, cel_xpath(row_number, 3)) do
            expect(page).to have_content(amount)
            expect(page).not_to have_content("#{amount} *")
          end
        end

        # check the "date" column
        within(:xpath, cel_xpath(row_number, 4)) do
          expect(page).to have_content(bid.time)
        end
      end
    end
  end
end
