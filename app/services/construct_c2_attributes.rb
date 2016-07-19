class ConstructC2Attributes
  OFFICE = 'DC'.freeze
  PURCHASE_TYPE = 'Micropurchase'.freeze
  QUANTITY = 1
  RECURRING = false
  URGENCY = 20

  def initialize(auction)
    @auction = auction
  end

  def perform
    {
      gsa18f_procurement: {
        office: OFFICE,
        purchase_type: PURCHASE_TYPE,
        product_name_and_description: product_name_and_description,
        justification: justification,
        cost_per_unit: cost_per_unit,
        quantity: QUANTITY,
        recurring: RECURRING,
        date_requested: date_requested,
        urgency: URGENCY
      }
    }
  end

  private

  attr_reader :auction

  def product_name_and_description
    %(Micro-purchase for '#{auction.title}'.

      Link: #{url}

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
    AuctionUrl.new(auction).find
  end
end
