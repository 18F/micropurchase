def create_current_auction
  @auction = Auction.create({
    start_datetime: Time.now - 3.days,
    end_datetime: Time.now + 3.days,
    title: 'Oh no, fix the world',
    description: 'it is broken!'
  })
  @bidder = User.create(github_id: 'uid', duns_number: 'duns')

  @auction.bids.create(bidder: @bidder, amount: 1000)
end

def sign_in_admin
  mock_github(uid: Admins.github_ids.first)
  visit "/auth/github"
  @admin = User.first
end
