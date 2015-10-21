class UsersController < ApplicationController
  def edit
    @user = User.find(params[:id])
    raise AuthorizationError if current_user != @user
  end

  def update
    require_authentication and return

    @user = User.find(params[:id])
    raise AuthorizationError if current_user != @user

    @user.update_attributes({
      sam_id:   params[:sam_id],
      duns_id:  params[:duns_id]
    })

    redirect_to '/'
  end
end
