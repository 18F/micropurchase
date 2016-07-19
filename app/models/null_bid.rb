class NullBid
  def amount
    nil
  end

  def bidder
    nil
  end

  def bidder_id
    nil
  end

  def bidder_name
    nil
  end

  def decorated_bidder
    NullBidder.new
  end
end
