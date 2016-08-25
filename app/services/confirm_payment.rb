class ConfirmPayment
  def initialize(auction)
    @auction = auction
  end

  def perform
    auction.update(c2_status: :payment_confirmed)
    add_receipt_to_c2_proposal
  end

  private

  attr_reader :auction

  def add_receipt_to_c2_proposal
    UpdateC2ProposalJob.perform_later(auction.id,
                                      'AddReceiptToC2ProposalAttributes')
  end
end
