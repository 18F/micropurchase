class StartPriceThresholds < Struct.new(:start_price)
  MICROPURCHASE = 3500
  SAT = 150000

  def small_business?
    (MICROPURCHASE + 1..SAT).cover?(start_price)
  end
end
