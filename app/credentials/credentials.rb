class Credentials
  def get(*name)
    type_delegate.get(*name)
  end

  def self.get(*name)
    new.get(*name)
  end

  private

  def type_delegate
    @credentials_delegate ||= local? ? Local.new : CloudFoundry.new
  end

  def local?
    ['development', 'test'].include?(Rails.env)
  end
end
