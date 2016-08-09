require_relative 'response'

class Swagger::Operation
  include Swagger::Mixins::Description

  attr_accessor :fields

  def initialize(path, verb, fields, specification)
    @fields = fields.merge('verb' => verb, 'path' => path)
    @specification = specification
  end

  # fields not needed yet: consumes, deprecated, produces, schemes, tags
  def description
    fields['description']
  end

  def path
    fields['path']
  end

  def summary
    fields['summary']
  end

  def title
    fields['title']
  end

  def verb
    fields['verb']
  end

  def sample_json_response?
    !sample_json_response.blank?
  end

  # shorthand to pull an example response
  def sample_json_response
    if @_sample_response.nil?
      example_json = fields.dig('responses', '200', 'examples', 'application/json')
      if example_json
        @_sample_response = JSON.pretty_generate(example_json).strip
      end
    end

    @_sample_response
  end

  def responses
    responses_hash.values
  end

  def operation_id
    fields['operationId']
  end

  def unique_key
    operation_id || "#{verb}-#{path.gsub(%r([/\{\}]), '-').gsub(/\-\-+/, '-').gsub(/(^\-)|(\-$)/, '')}"
  end

  private

  def responses_hash
    if @_responses_hash.nil?
      @_responses_hash = { }
      fields['responses'].each do |code, response_hash|
        @_responses_hash[code] = Swagger::Response.new(code, response_hash, @specification)
      end
    end

    @_responses_hash
  end
end
