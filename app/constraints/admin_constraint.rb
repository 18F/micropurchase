class AdminConstraint
  def matches?(request)
    user = current_user(request)
    Admins.verify?(user.github_id)
  end

  def current_user(request)
    User.where(id: request.session[:user_id]).first || Guest.new
  end
end
