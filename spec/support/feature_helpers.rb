def create_current_auction
  @auction = Auction.create({
    start_datetime: Time.now - 3.days,
    end_datetime: Time.now + 3.days,
    title: 'Oh no, fix the world',
    description: 'it is broken!',
    issue_url: 'https://github.com/18F/calc/issues/255',
    github_repo: 'https://github.com/18F/calc'
  })
  @bidder = User.create(github_id: 'uid', duns_number: 'duns')

  @auction.bids.create(bidder: @bidder, amount: 1000)
end

def sign_in_admin
  mock_github(uid: Admins.github_ids.first)
  visit "/auth/github"
  @admin = User.first
end

def sign_in_bidder
  click_on "Login"
  click_on("Authorize with GitHub")
  fill_in("user_duns_number", with: "123-duns")
  click_on('Submit')
end

def create_authed_bidder
  @bidder = User.create(github_id: current_user_uid, duns_number: 'DUNS-123')
end
