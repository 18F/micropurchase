class Swagger::Schema
end

require_relative 'schema/all_of'
require_relative 'schema/any_of'
require_relative 'schema/boolean'
require_relative 'schema/number'
require_relative 'schema/string'
require_relative 'schema/array'
require_relative 'schema/object'

class Swagger::Schema
  include Swagger::Mixins::Description

  attr_accessor :fields

  def initialize(name, fields, specification)
    @fields = Hashie::Mash.new(fields.merge(name: name))
    @specification = specification
  end

  delegate :default,
           :description,
           :enum,
           :format,
           :maximum,
           :minimum,
           :name,
           :pattern,
           :title,
           :type,
           to: :fields

  def unique_key
    "definition-#{name}"
  end

  def sample_value
    if fields.key?('x-example')
      fields['x-example']
    else
      default_sample_value
    end
  end

  def self.factory(name, fields, specification)
    if fields.key?('$ref')
      Swagger::Reference.new(name, fields, specification)
    elsif fields.key?('allOf')
      Swagger::Schema::AllOf.new(name, fields, specification)
    else
      case fields['type']
      when ::Array
        Swagger::Schema::AnyOf.new(name, fields, specification)
      when 'string'
        Swagger::Schema::String.new(name, fields, specification)
      when 'integer', 'number', 'boolean'
        Swagger::Schema::Number.new(name, fields, specification)
      when 'boolean'
        Swagger::Schema::Boolean.new(name, fields, specification)
      when 'array'
        Swagger::Schema::Array.new(name, fields, specification)
      when 'object', nil
        Swagger::Schema::Object.new(name, fields, specification)
      else
        fail "Unhandled property type: #{fields.inspect}"
      end
    end
  end
end
