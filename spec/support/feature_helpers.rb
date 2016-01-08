def create_user
  @user = FactoryGirl.create(:user)
end

# rubocop:disable Style/RedundantReturn
def create_bidless_auction(end_datetime: Time.now + 3.days)
  @auction = FactoryGirl.create(:auction, end_datetime: end_datetime)
  @bidders = []

  return @auction, @bidders
end

def create_closed_bidless_auction
  create_bidless_auction
  @auction.end_datetime = Time.now - 1.day
  @auction.save
end

def create_current_auction
  @auction = FactoryGirl.create(:auction, :with_bidders)
  @bidders = @auction.bids

  return @auction, @bidders
end

def create_closed_and_current_auctions(closed: 5, current: 5)
  @current_auctions = current.times.to_a.map do
    FactoryGirl.create(:auction, :running, title: Faker::Commerce.product_name)
  end
  @closed_auctions = closed.times.to_a.map do
    FactoryGirl.create(:auction, :closed, title: Faker::Commerce.product_name)
  end

  return @current_auctions, @closed_auctions
end

def create_closed_auction
  @auction = FactoryGirl.create(:auction, :closed, :with_bidders)
  @bidders = @auction.bids

  return @auction, @bidders
end
# rubocop:enable Style/RedundantReturn

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
  @bidder = FactoryGirl.create(:user, github_id: current_user_uid, name: 'Doris Doogooder')
end

def show_page
  # quickly view the page visited by Capybara
  # requires the local server to be running
  # for more info: https://coderwall.com/p/jsutlq/capybara-s-save_and_open_page-with-css-and-js
  save_page Rails.root.join('public', 'capybara.html')
  `launchy http://localhost:3000/capybara.html`
end

def cel_xpath(row_number, column_number)
  "//table/tbody/tr[#{row_number}]/td[#{column_number}]"
end
