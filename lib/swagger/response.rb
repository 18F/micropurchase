class Swagger::Response
  include Swagger::Mixins::Description

  attr_accessor :fields

  def initialize(code, fields, specification)
    @fields = fields.merge('code' => code)
    @specification = specification
  end

  def code
    fields['code']
  end

  def description
    fields['description']
  end

  def displayed_type
    schema.displayed_type
  end

  def schema
    Swagger::Schema.factory(nil, fields['schema'], @specification)
  end
end
