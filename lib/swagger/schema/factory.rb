class Swagger::Schema::Factory
  attr_reader :name, :fields, :specification

  def initialize(name, fields, specification)
    @name = name
    @fields = fields
    @specification = specification
  end

  def call
    if fields.key?('$ref')
      Swagger::Reference.new(name, fields, specification)
    elsif fields.key?('allOf')
      Swagger::Schema::AllOf.new(name, fields, specification)
    else
      other_schema_by_type
    end
  end

  private

  def other_schema_by_type
    fail "Unhandled property type: #{fields.inspect}" unless valid_type?
    typed_schema_element
  end

  def typed_schema_element
    array_class || string || number || boolean || array || object
  end

  def string
    return unless type == 'string'
    Swagger::Schema::String.new(name, fields, specification)
  end

  def number
    return unless number_type?
    Swagger::Schema::Number.new(name, fields, specification)
  end

  def boolean
    return unless type == 'boolean'
    Swagger::Schema::Boolean.new(name, fields, specification)
  end

  def array
    return unless type == 'array'
    Swagger::Schema::Array.new(name, fields, specification)
  end

  def object
    return if !(type == 'object') && type.nil?
    Swagger::Schema::Object.new(name, fields, specification)
  end

  def type
    fields['type']
  end

  def valid_type?
    array_class? ||
      ['string', 'integer', 'number', 'boolean', 'boolean', 'array', 'object', nil].include?(type)
  end

  def number_type?
    type == 'integer' || type == 'number'
  end

  def array_class?
    type.class == ::Array
  end

  def array_class
    return unless array_class?
    fail "Unhandled array type: #{fields.inspect}" unless valid_array_class?
    recurse_for_array
  end

  def valid_array_class?
    type.size == 2 && type.last == 'null'
  end

  def recurse_for_array
    self.class.new(name, fields.merge('nullable' => true, 'type' => type.first), specification).call
  end
end
