require_relative '../schema'

class Swagger::Schema::AnyOf < Swagger::Schema
  def compact_type
    type.join(', ')
  end

  def default_sample_value
    'xxx'
  end
end
