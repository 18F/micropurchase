class RegisterUser
  attr_reader :github_id

  def initialize(params)
    @github_id = params[:github_id]
  end

  def perform
    @_user ||= User.create(github_id: github_id)
  end
end
