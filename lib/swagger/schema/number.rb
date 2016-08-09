class Swagger::Schema::Number < Swagger::Schema
  def displayed_type
    out = type.dup

    if min? && max?
      out << " (#{min_display_left} n #{max_display_right})"
    elsif min?
      out << " (n #{min_display_right})"
    elsif max?
      out << " (n #{max_display_right})"
    end

    out
  end

  def default_sample_value
    case type
    when 'integer'
      39
    when 'number'
      39.4
    else
      ''
    end
  end

  private

  def min?
    fields['minimum']
  end

  def max?
    fields['maximum']
  end

  def max_display_right
    operator = fields['exclusiveMaximum'] ? '<' : '<='
    "#{operator} #{fields['maximum']}"
  end

  def min_display_right
    operator = fields['exclusiveMinimum'] ? '>' : '>='
    "#{operator} #{fields['minimum']}"
  end

  def min_display_left
    operator = fields['exclusiveMinimum'] ? '<' : '<='
    "#{fields['minimum']} #{operator}"
  end
end
