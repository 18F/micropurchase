class UserWithAssertedAttributes
  def initialize(user)
    @user = user
  end

  def call(attrs)
    self.asserted_attributes = attrs
  end

  delegate :email, :uid, to: :user

  attr_reader :asserted_attributes

  private

  attr_reader :user
  attr_writer :asserted_attributes
end
