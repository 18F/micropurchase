class Average
  attr_reader :value, :count, :type

  def initialize(value, count, type = nil)
    @value = value
    @count = count
    @type = type
  end

  def to_s
    if count.positive?
      calculate
    else
      'n/a'
    end
  end

  private

  def calculate
    if type == 'time'
      HumanTime.new(time: (value / count)).distance_of_time
    elsif type == 'price'
      Currency.new(value / count).to_s
    else
      (value / count.to_f).round
    end
  end
end
