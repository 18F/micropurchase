class C2CancelAttributes
  def initialize(auction)
    @auction = auction
  end

  def to_h
    {
      status: 'canceled',
      gsa18f_procurement: {
        additional_info: additional_info
      }
    }
  end

  private

  attr_accessor :auction

  def additional_info
    "Reason canceled: #{reason_canceled}"
  end

  def reason_canceled
    if auction.archived?
      'the auction was archived'
    elsif auction.rejected?
      'the auction was rejected'
    else
      'unknown'
    end
  end
end
