module BidsHelper
  def content_for_row(row_number, bid)
    if row_number == 0
      "#{number_to_currency(bid.amount)} *"
    else
      number_to_currency(bid.amount)
    end
  end
end
