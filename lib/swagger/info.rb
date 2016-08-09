class Swagger::Info
  attr_accessor :fields

  def initialize(fields)
    @fields = fields
  end

  def description
    fields['description']
  end

  def title
    fields['title']
  end

  def version
    fields['version']
  end

  def contact_email
    contact['email']
  end

  def contact_name
    contact['name']
  end

  def contact_url
    contact['url']
  end

  def license_name
    license['name']
  end

  def license_url
    license['url']
  end

  def terms_of_service
    fields['termsOfService']
  end

  private

  def contact
    fields['contact'] || { }
  end

  def license
    fields['license'] || { }
  end
end
