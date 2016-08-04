class Swagger::Reference
  attr_accessor :name, :fields

  def initialize(name, fields, specification)
    @name = name
    @fields = fields.dup
    @specification = specification
    fail "This isn't a reference: #{fields.inspect}" unless fields['$ref']
  end

  def normalized_ref_string
    fields['$ref'].gsub(/^#/, '')
  end

  def dereferenced?
    @_dereferenced != nil
  end

  def compact_type
    normalized_ref_string.gsub(/.+\//, '')
  end

  def dereferenced
    unless dereferenced?
      pointer = Hana::Pointer.new(normalized_ref_string)
      target = pointer.eval(@specification.json)
      fail "Unable to dereference #{normalized_ref_string}" if target.nil?
      @_dereferenced = Swagger::Schema.factory(@name, target, @specification)
    end

    @_dereferenced
  end

  delegate :description,
           :properties,
           :summary,
           :title,
           to: :dereferenced
end
