module BidsHelper
  def content_for_row(row_number, bid)
    if row_number == 0
      "#{number_to_currency(bid.amount)} *"
    else
      number_to_currency(bid.amount)
    end
  end

  def user_is_winning_bidder?(user, auction)
    return false if !auction.current_bid?

    user.id == auction.current_bid.bidder_id
  end
end
