class UpdateC2Attributes
  def initialize(auction)
    @auction = auction
  end

  def perform
    {
      gsa18f_procurement: {
        cost_per_unit: cost_per_unit,
        link_to_product: link_to_product,
        additional_info: additional_info
      }
    }
  end

  private

  attr_reader :auction

  def cost_per_unit
    winning_bid.amount
  end

  def link_to_product
    auction.delivery_url
  end

  def additional_info
    if auction.accepted?
      %(Vendor name: #{winning_bid.bidder.name}
        Vendor email: #{winning_bid.bidder.email}
        Vendor DUNS: #{winning_bid.bidder.duns_number}
        Use the following credit card form: #{winning_bid.bidder.credit_card_form_url}.)
    end
  end

  def winning_bid
    WinningBid.new(auction).find
  end
end
