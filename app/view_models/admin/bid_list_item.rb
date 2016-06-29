class Admin::BidListItem
  attr_reader :bid, :user

  def initialize(bid:, user:)
    @bid = bid
    @user = user
  end

  def veiled_name
    bid.bidder.name
  end

  def veiled_duns_number
    bid.bidder.duns_number
  end

  def amount_to_currency_with_asterisk
    if bid == bid.auction.lowest_bid
      "#{amount_to_currency} *"
    else
      amount_to_currency
    end
  end

  def created_at
    DcTimePresenter.convert_and_format(bid.created_at)
  end

  private

  def amount_to_currency
    Currency.new(bid.amount).to_s
  end

  def auction_available?
    AuctionStatus.new(bid.auction).available?
  end

  def bidder_not_user?
    bid.bidder != user
  end
end
