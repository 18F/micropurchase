class Swagger::Info
  attr_accessor :fields

  def initialize(fields)
    @fields = Hashie::Mash.new(fields)
  end

  delegate :description,
           :title,
           :version,
           to: :fields

  delegate :email,
           :name,
           :url,
           to: :contact,
           prefix: true

  delegate :name,
           :url,
           to: :license,
           prefix: true

  def terms_of_service
    fields.termsOfService
  end

  def contact
    fields['contact'] || {}
  end

  def license
    fields['license'] || {}
  end
end
