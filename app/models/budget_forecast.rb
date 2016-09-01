class BudgetForecast
  def initialize(monthly_limit: , month:)
    @monthly_limit = monthly_limit
    @month = month
  end

  def minimum_available_dollars
    (monthly_limit - (paid_amount +
                      owed_amount +
                      obligated_amount))
  end

  private

  attr_reader :monthly_limit, :month

  def paid_amount
    sum_of_winning_bids(
      AuctionQuery.new.paid_within_month(month)
    )
  end

  def owed_amount
    sum_of_winning_bids(
      AuctionQuery.new.payment_needed
    )
  end

  def obligated_amount
    sum_of_winning_bids(
      AuctionQuery.new.obligated_within_month(month)
    )
  end

  def sum_of_winning_bids(auctions)
    auctions
      .map { |auction| WinningBid.new(auction).find.amount }
      .inject(:+)
  end
end
