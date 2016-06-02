class ConstructCapAttributes
  OFFICE = 'DC'.freeze
  PURCHASE_TYPE = 'Software'.freeze
  QUANTITY = 1
  RECURRING = false
  URGENCY = 20

  def initialize(auction)
    @auction = auction
  end

  def perform
    {
      gsa18f_procurement: {
        office: ConstructCapAttributes::OFFICE,
        purchase_type: ConstructCapAttributes::PURCHASE_TYPE,
        product_name_and_description: product_name_and_description,
        justification: justification,
        link_to_product: link_to_product,
        cost_per_unit: cost_per_unit,
        quantity: ConstructCapAttributes::QUANTITY,
        recurring: ConstructCapAttributes::RECURRING,
        date_requested: date_requested,
        urgency: ConstructCapAttributes::URGENCY,
        additional_info: additional_info
      }
    }
  end

  private

  attr_reader :auction

  def product_name_and_description
    %(Micropurchase for '#{auction.title}'.

      Link: #{url}

      Summary:

      #{auction.summary})
  end

  def link_to_product
    auction.delivery_url
  end

  def justification
    "Billable to the '#{auction.billable_to}' Tock line item."
  end

  def cost_per_unit
    winning_bid.amount
  end

  def date_requested
    Date.current.iso8601
  end

  def additional_info
    %(Vendor name: #{winning_bid.bidder.name}
      Vendor email: #{winning_bid.bidder.email}
      Vendor DUNS: #{winning_bid.bidder.duns_number}
      Use the following credit card form: #{winning_bid.bidder.credit_card_form_url}.)
  end

  def winning_bid
    WinningBid.new(auction).find
  end

  def url
    AuctionUrl.new(auction).find
  end
end
