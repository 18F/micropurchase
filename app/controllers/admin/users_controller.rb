module Admin
  class UsersController < ApplicationController
    before_filter :require_admin

    def index
      all_users = User.all.map {|user| Presenter::User.new(user) }
      @admins, @users = all_users.partition(&:admin?)
      @admin_report = AdminReport.new(users: all_users)

      respond_to do |format|
        format.html
        format.json do
          render json: @admin_report, serializer: Admin::AdminReportSerializer
        end
      end
    end

    def show
      @user = Presenter::User.new(User.find(params[:id]))
    end
  end
end
