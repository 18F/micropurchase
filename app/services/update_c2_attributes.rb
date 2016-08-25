class UpdateC2Attributes
  def initialize(auction)
    @auction = auction
  end

  def perform
    {
      gsa18f_procurement: {
        cost_per_unit: cost_per_unit,
        additional_info: additional_info
      }
    }
  end

  private

  attr_reader :auction

  def cost_per_unit
    winning_bid.amount
  end

  def additional_info
    if auction.accepted?
      %(Vendor name: #{winning_bid.bidder.name}
        Vendor email: #{winning_bid.bidder.email}
        Vendor DUNS: #{winning_bid.bidder.duns_number}
        Use the following credit card form: #{winning_bid.bidder.payment_url}.
        Pull request URL: #{auction.delivery_url})
    end
  end

  def winning_bid
    WinningBid.new(auction).find
  end
end
