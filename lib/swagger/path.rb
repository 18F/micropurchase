require_relative 'operation'

class Swagger::Path
  attr_accessor :path, :fields, :operations

  def initialize(path, fields, specification)
    @path = path
    @fields = fields
    @specification = specification
  end

  def operations
    operations_hash.values
  end

  private

  def operations_hash
    if @_operations_hash.nil?
      @_operations_hash = {}
      fields.each do |verb, values|
        @_operations_hash[verb] = Swagger::Operation.new(verb, values, @specification)
      end
    end

    @_operations_hash
  end
end
