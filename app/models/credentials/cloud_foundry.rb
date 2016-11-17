class Credentials::CloudFoundry
  attr_reader :data

  def get(namespace, key = nil)
    service(namespace)[key] || local(namespace, key)
  end

  def service(namespace)
    services.find { |service| service['name'] == namespace } || { }
  end

  def services
    @services ||= JSON.parse(ENV['VCAP_SERVICES'])['user-provided']
  end

  def local(namespace, key)
    key ? Local.new.get(namespace, key) : Credentials::Local.new.get(namespace)
  end
end
