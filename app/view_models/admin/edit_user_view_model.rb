class Admin::EditUserViewModel < Admin::BaseViewModel
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def record
    user
  end
end
