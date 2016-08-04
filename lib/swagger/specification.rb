require 'open-uri'

require_relative 'reference'
require_relative 'info'
require_relative 'path'
require_relative 'schema'

class Swagger::Specification
  attr_accessor :json

  def self.load_json(path)
    json = nil
    open(path) { |file| json = JSON.parse(file.read) }
    new(json)
  end

  def initialize(json)
    @json = json
  end

  def swagger_version
    @json['swagger']
  end

  def base_path
    @json['basePath']
  end

  def security
    @json['security']
  end

  def info
    Swagger::Info.new(@json['info'])
  end

  def paths
    paths_hash.values
  end

  def path(name)
    paths_hash[name]
  end

  def definition(name)
    definitions_hash[name]
  end

  def definitions
    definitions_hash.values
  end

  def inspect
    "<<specification>>"
  end

  private

  def paths_hash
    if @_paths_hash.nil?
      @_paths_hash = {}
      @json['paths'].each do |name, value|
        @_paths_hash[name] = Swagger::Path.new(name, value, self)
      end
    end

    @_paths_hash
  end

  def definitions_hash
    if @_definitions_hash.nil?
      @_definitions_hash = {}

      @json['definitions'].each do |name, hash|
        @_definitions_hash[name] = Swagger::Schema.factory(name, hash, self)
      end
    end

    @_definitions_hash
  end
end
