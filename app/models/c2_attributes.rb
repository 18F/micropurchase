class C2Attributes
  OFFICE = 'DC'.freeze
  PURCHASE_TYPE = 'Micropurchase'.freeze
  QUANTITY = 1
  RECURRING = false
  URGENCY = 20

  def initialize(auction)
    @auction = auction
  end

  def to_h
    {
      gsa18f_procurement: {
        cost_per_unit: cost_per_unit,
        date_requested: date_requested,
        justification: justification,
        link_to_product: url,
        office: OFFICE,
        product_name_and_description: product_name_and_description,
        purchase_type: PURCHASE_TYPE,
        quantity: QUANTITY,
        recurring: RECURRING,
        urgency: URGENCY
      }
    }
  end

  private

  attr_reader :auction

  def product_name_and_description
    %(Micro-purchase for '#{auction.title}'.

      Summary:

      #{auction.summary})
  end

  def justification
    "Tock line item: #{auction.billable_to}"
  end

  def cost_per_unit
    auction.start_price
  end

  def date_requested
    Date.current.iso8601
  end

  def url
    AuctionUrl.new(auction: auction).to_s
  end
end
