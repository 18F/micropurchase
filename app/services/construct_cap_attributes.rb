class ConstructCapAttributes
  OFFICE = 'DC'.freeze
  PURCHASE_TYPE = 'Software'.freeze
  QUANTITY = 1
  RECURRING = false
  URGENCY = 20

  def initialize(auction_presenter)
    @auction = auction_presenter
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

  def product_name_and_description
    %(Micropurchase for '#{@auction.title}'.

      Link: #{@auction.url}

      Summary:

      #{@auction.summary})
  end

  def link_to_product
    @auction.delivery_url
  end

  def justification
    "Billable to the '#{@auction.billable_to}' Tock line item."
  end

  def cost_per_unit
    @auction.winning_bid.amount
  end

  def date_requested
    Date.current.iso8601
  end

  def additional_info
    %(Vendor name: #{@auction.winning_bid.bidder.name}
      Vendor email: #{@auction.winning_bid.bidder.email}
      Vendor DUNS: #{@auction.winning_bid.bidder.duns_number}
      Use the following credit card form: #{@auction.winning_bid.bidder.credit_card_form_url}.)
  end
end
