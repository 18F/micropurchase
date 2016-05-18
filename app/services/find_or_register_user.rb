class FindOrRegisterUser
  attr_reader :github_id

  def initialize(params)
    @github_id = params[:github_id]
  end

  def perform
    user = found_user = find_user

    if found_user.nil?
      user = register_user
    end

    user
  end

  private

  def find_user
    User.where(github_id: github_id).first
  end

  def register_user
    RegisterUser.new(github_id: github_id).perform
  end
end
