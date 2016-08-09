require_relative '../schema'

class Swagger::Schema::Object < Swagger::Schema
  def type
    'object'
  end

  def properties
    properties_hash.values
  end

  def property(key)
    properties_hash[key]
  end

  def displayed_type
    "<a href=\"##{unique_key}\">#{name}</a>".html_safe
  end

  def default_sample_value
    "<< #{displayed_type} >>".html_safe
  end

  private

  def properties_hash
    if @_properties.nil?
      @_properties = { }

      if fields.key?('properties')
        fields['properties'].each do |name, value|
          @_properties[name] = Swagger::Schema.factory(name, value, @specification)
        end
      end
    end

    @_properties
  end
end
