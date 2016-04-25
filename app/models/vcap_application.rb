class VCAPApplication
  def self.application_uris
    vcap_application['application_uris']
  end

  def self.vcap_application
    JSON.parse(ENV['VCAP_APPLICATION'])['VCAP_APPLICATION']
  end
end
