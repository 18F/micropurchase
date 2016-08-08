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

  def properties_json
    str = <<-EOF
    {
      "id": 34, // nullable
      "github_id": 3402, // nullable
      "duns_number": "123456789", // nullable
      "name": "Micah Purchase", // nullable
      "github_login": "github_login", // nullable
      "sam_status": "sam_accepted", // nullable
      "created_at": "2016-01-01T13:00:00Z", // nullable
      "updated_at": "2016-01-01T13:00:00Z" // nullable
    }
    EOF

    formatter = Rouge::Formatters::HTML.new(css_class: 'highlight')
    lexer = Rouge::Lexer.find('json')
    out = formatter.format(lexer.lex(str)).html_safe

    raise out.inspect
  end

  private

  def properties_hash
    if @_properties.nil?
      @_properties = {}

      if fields.key?('properties')
        fields['properties'].each do |name, value|
          @_properties[name] = Swagger::Schema.factory(name, value, @specification)
        end
      end
    end

    @_properties
  end
end
