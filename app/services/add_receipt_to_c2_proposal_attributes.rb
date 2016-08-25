class AddReceiptToC2ProposalAttributes
  def initialize(auction)
    @auction = auction
  end

  def perform
    {
      gsa18f_procurement: {
        link_to_product: link_to_product
      }
    }
  end

  private

  attr_reader :auction

  def link_to_product
    ReceiptUrl.new(auction).to_s
  end
end
