def create_user
  @user = FactoryGirl.create(:user)
end

def create_bidless_auction(end_datetime: Time.now + 3.days)
  @auction = FactoryGirl.create(:auction, end_datetime: Time.now + 3.days)
  @bidders = []
  
  return @auction, @bidders
end

def create_current_auction
  @auction = FactoryGirl.create(:current_auction)
  @bidders = @auction.bids
  
  return @auction, @bidders
end

def create_closed_auction
  @auction = FactoryGirl.create(:closed_auction)
  @bidders = @auction.bids
  return @auction, @bidders
end

def create_running_auction
  @auction = FactoryGirl.create(:running_auction)
  @bidders = @auction.bids

  return @auction, @bidders
end

def sign_in_admin
  mock_github(uid: Admins.github_ids.first)
  visit "/auth/github"
  @admin = User.first
end

def sign_in_bidder
  @bidder = create_authed_bidder
  click_on "Login"
  click_on("Authorize with GitHub")
  fill_in("user_duns_number", with: @bidder.duns_number)
  click_on('Submit')
end

def create_authed_bidder
  @bidder = FactoryGirl.create(:user, github_id: current_user_uid)
end

def show_page
  # quickly view the page visited by Capybara
  # requires the local server to be running
  # for more info: https://coderwall.com/p/jsutlq/capybara-s-save_and_open_page-with-css-and-js
  save_page Rails.root.join('public', 'capybara.html')
  %x(launchy http://localhost:3000/capybara.html)
end

def cel_xpath(row_number, column_number)
  "//table/tbody/tr[#{row_number}]/td[#{column_number}]"
end
