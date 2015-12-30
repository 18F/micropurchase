module Admin
  class UsersController < ApplicationController
    before_filter :require_admin

    def index
      all_users = User.all.map {|user| Presenter::User.new(user)}
      @admins, @users = all_users.partition {|u| u.is_admin?}
    end

    def show
      @user = Presenter::User.new(User.find(params[:id]))
    end

  end
end
