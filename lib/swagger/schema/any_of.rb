require_relative '../schema'

class Swagger::Schema::AnyOf < Swagger::Schema
  def compact_type
    type.join(', ')
  end
end
