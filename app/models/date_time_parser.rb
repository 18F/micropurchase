class DateTimeParser
  def initialize(attributes, field)
    @attributes = attributes
    @field = field
  end

  def parse
    DateTime.new(year, month, day, hour, minute)
  end

  private

  attr_reader :attributes, :field

  def year
    parsed_date[0].to_i
  end

  def month
    parsed_date[1].to_i
  end

  def day
    parsed_date[2].to_i
  end

  def hour
    time.strftime('%H').to_i
  end

  def minute
    time.strftime('%M').to_i
  end

  def parsed_date
    attributes[field].split("-")
  end

  def time
    Time.parse(time_fields)
  end

  def time_fields
    attributes["#{field}(1i)"] +
      ":" +
      attributes["#{field}(2i)"] +
      attributes["#{field}(3i)"]
  end
end
