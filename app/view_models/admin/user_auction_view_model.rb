class Admin::UserAuctionViewModel
  attr_reader :auction, :user

  DATE_FORMAT = '%m/%d/%Y'.freeze
  NA_RESPONSE_STRING = '-'.freeze

  def initialize(auction, user)
    @auction = auction
    @user = user
  end

  def title
    auction.title
  end

  def id
    auction.id
  end

  def status
    StatusPresenterFactory.new(auction).create.label
  end

  def skills
    auction.sorted_skill_names.join(', ')
  end

  def user_bid_count
    user_bids.count
  end

  def user_won_label
    if user_won?
      'Yes'
    elsif auction_over?
      'No'
    else
      NA_RESPONSE_STRING
    end
  end

  def accepted_label
    if user_won? && auction_accepted?
      'Yes'
    elsif user_won?
      'No'
    else
      NA_RESPONSE_STRING
    end
  end

  private

  def user_won?
    auction_over? && WinningBid.new(auction).find.bidder == user
  end

  def auction_over?
    AuctionStatus.new(auction).over?
  end

  def auction_accepted?
    auction.accepted?
  end

  def auction_rules
    RulesFactory.new(auction).create
  end

  def user_bids
    auction.bids.where(bidder: user).sort_by(&:amount)
  end
end
