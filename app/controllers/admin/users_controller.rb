module Admin
  class UsersController < ApplicationController
    before_filter :require_admin

    def index
      @users = User.all.map {|user| Presenter::User.new(user)}
    end

    def show
      @user = Presenter::User.new(User.find(params[:id]))
    end

  end
end
