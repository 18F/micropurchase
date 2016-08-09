require_relative '../schema'

class Swagger::Schema::String < Swagger::Schema
  def displayed_type
    out = "string"
    out += " (#{format})" if format
    out
  end

  def default_sample_value
    case format
    when 'date-time'
      '"2016-01-01T13:00:00Z"'
    when 'email'
      '"user@example.com"'
    when 'hostname'
      '"example.com"'
    when 'url'
      '"http://example.com/"'
    when 'markdown'
      '"A **markdown** string"'
    when 'duns'
      '"123456789"'
    else
      '"example"'
    end
  end
end
