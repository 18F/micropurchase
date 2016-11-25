require_relative '../schema'

class Swagger::Schema::String < Swagger::Schema
  def displayed_type
    out = "string"
    out += " (#{format})" if format
    out
  end

  def default_sample_value
    value_for_format(format) || '"example"'
  end

  def value_for_format(format)
    {
      'date-time' => '"2016-01-01T13:00:00Z"',
      'email'     => '"user@example.com"',
      'hostname'  => '"example.com"',
      'url'       => '"http://example.com/"',
      'markdown'  => '"A **markdown** string"',
      'duns'      => '"123456789"'
    }[format]
  end
end
