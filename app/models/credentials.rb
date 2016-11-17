class Credentials
  def get(*name)
    type_delegate.get(*name)
  end

  def self.get(*name)
    new.get(*name)
  end

  def self.map(method_name, options)
    define_singleton_method(method_name) do
      new.get(options[:to])
    end
  end

  private

  def type_delegate
    @credentials_delegate ||= local? ? Local.new : CloudFoundry.new
  end

  def local?
    Rails.env == 'development' || Rails.env == 'test'
  end
end
