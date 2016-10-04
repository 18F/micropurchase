class C2CancelAttributes
  def initialize(auction)
    @auction = auction
  end

  def to_h
    {
      status: 'cancelled',
      gsa18f_procurement: {
        additional_info: additional_info
      }
    }
  end

  private

  attr_accessor :auction

  def additional_info
    "Reason cancelled: #{reason_cancelled}"
  end

  def reason_cancelled
    if auction.archived?
      'the auction was archived'
    elsif auction.rejected?
      'the auction was rejected'
    else
      'unknown'
    end
  end
end
