class Credentials
  def get(*name)
    type_delegate.get(*name)
  end

  # method missing for convenience

  private

  def type_delegate
    @credentials_delegate ||= local? ? Local.new : CloudFoundry.new
  end

  def local?
    ['development', 'test'].include?(Rails.env)
  end
end
