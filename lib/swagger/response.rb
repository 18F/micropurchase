class Swagger::Response
  attr_accessor :fields

  def initialize(code, fields, specification)
    @fields = fields.merge(code: code)
    @specification = specification
  end

  # don't need headers

  delegate :code,
           :description,
           to: :fields

  def compact_type
    schema.compact_type
  end

  def schema
    Swagger::Schema.factory(nil, fields['schema'], @specification)
  end
end
