class Currency
  include ActionView::Helpers::NumberHelper

  attr_reader :amount

  def initialize(amount)
    @amount = amount
  end

  def to_s
    number_to_currency(amount)
  end
end
