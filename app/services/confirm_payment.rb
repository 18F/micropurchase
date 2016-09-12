class ConfirmPayment
  def initialize(auction)
    @auction = auction
  end

  def perform
    auction.update(c2_status: :payment_confirmed)
  end

  private

  attr_reader :auction
end
