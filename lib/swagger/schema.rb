class Swagger::Schema
end

require_relative 'mixins/description'
require_relative 'schema/all_of'
require_relative 'schema/boolean'
require_relative 'schema/number'
require_relative 'schema/string'
require_relative 'schema/array'
require_relative 'schema/object'
require_relative 'schema/factory'

class Swagger::Schema
  include Swagger::Mixins::Description

  attr_accessor :fields

  def initialize(name, fields, specification)
    @fields = fields.merge('name' => name)
    @specification = specification
  end

  def default
    fields['default']
  end

  def description
    fields['description']
  end

  def enum
    fields['enum']
  end

  def format
    fields['format']
  end

  def name
    fields['name']
  end

  def nullable
    fields['nullable']
  end

  def title
    fields['title']
  end

  def type
    fields['type']
  end

  def unique_key
    "definition-#{name}"
  end

  def comment
    fields['x-comment']
  end

  def sample_value
    if fields.key?('example')
      fields['example'].inspect
    elsif fields.key?('enum')
      fields['enum'].first.inspect
    else
      default_sample_value
    end
  end

  def property_json_line
    "  \"#{name}\": #{sample_value}".html_safe
  end

  def self.factory(name, fields, specification)
    Swagger::Schema::Factory.new(name, fields, specification).call
  end
end
