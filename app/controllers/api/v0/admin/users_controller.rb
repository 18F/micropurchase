class Api::V0::Admin::UsersController < ApiController
  before_filter :require_admin

  def index
    users = User.all.map { |user| UserPresenter.new(user) }
    render json: AdminReport.new(users: users), serializer: ::Admin::AdminReportSerializer
  end
end
