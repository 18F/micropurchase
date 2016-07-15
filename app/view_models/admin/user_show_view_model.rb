class Admin::UserShowViewModel < Admin::BaseViewModel
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def name
    user.name
  end

  def email
    user.email
  end

  def payment_url
    user.payment_url
  end

  def duns_number
    user.duns_number
  end

  def github_id
    user.github_id
  end

  def github_login
    user.github_login
  end

  def sam_status
    user.sam_status
  end

  def small_business
    if user.small_business?
      "Yes"
    else
      "No"
    end
  end

  def contracting_officer
    if user.contracting_officer?
      "Yes"
    else
      "No"
    end
  end

  def bids_partial
    if bids?
      'bid_history'
    else
      'components/null'
    end
  end

  def bids?
    user_auctions.count > 0
  end

  def user_auctions
    AuctionQuery.new.with_bid_from_user(user.id).map { |auction| Admin::UserAuctionViewModel.new(auction, user) }
  end
end
