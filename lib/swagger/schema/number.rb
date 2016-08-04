class Swagger::Schema::Number < Swagger::Schema
  def compact_type
    out = type.dup

    if has_min? && has_max?
      out << " (#{min_display_left} n #{max_display_right})"
    elsif has_min?
      out << " (n #{min_display_right})"
    elsif has_max?
      out << " (n #{max_display_right})"
    end

    out
  end

  def sample_value
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

  def has_min?
    fields['minimum']
  end

  def has_max?
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
