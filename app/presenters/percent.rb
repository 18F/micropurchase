class Percent
  include ActionView::Helpers::NumberHelper

  attr_reader :numerator, :denominator

  def initialize(numerator, denominator)
    @numerator = numerator
    @denominator = denominator
  end

  def to_s
    number_to_percentage(
      (numerator.to_f / denominator) * 100,
      precision: 0
    )
  end
end
