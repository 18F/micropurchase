module CloudFoundry
  def self.vcap_data
    if environment?
      JSON.parse(raw_vcap_data)
    end
  end

  def self.instance_index
    if environment?
      vcap_data['instance_index']
    end
  end

  # returns `true` if this app is running in Cloud Foundry
  def self.environment?
    raw_vcap_data.present?
  end

  def self.raw_vcap_data
    ENV['VCAP_APPLICATION']
  end
end
