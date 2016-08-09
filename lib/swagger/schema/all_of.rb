require_relative '../schema'

class Swagger::Schema::AllOf < Swagger::Schema
  def type
    'allOf'
  end

  def properties
    fields['allOf'].map { |h| Swagger::Schema.factory(nil, h, @specification).properties }.flatten
  end
end
