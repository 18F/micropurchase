class Swagger::Response
  include Swagger::Mixins::Description

  attr_accessor :fields

  def initialize(code, fields, specification)
    @fields = fields.merge(code: code)
    @specification = specification
  end

  # don't need headers

  delegate :code,
           :description,
           to: :fields

  def displayed_type
    schema.displayed_type
  end

  def schema
    Swagger::Schema.factory(nil, fields['schema'], @specification)
  end
end
