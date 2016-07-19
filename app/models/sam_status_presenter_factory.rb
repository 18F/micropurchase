class SamStatusPresenterFactory
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def create
    Object.const_get("SamStatusPresenter::#{sam_status.camelize}").new
  end

  private

  def sam_status
    if user.sam_status =~ /sam/
      user.sam_status.gsub('sam_', '')
    else
      user.sam_status
    end
  end
end
