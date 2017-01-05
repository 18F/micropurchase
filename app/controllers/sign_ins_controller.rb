class SignInsController < ApplicationController
  def show
  end

  def show_admin
    @admin_sign_in = true
    render "show"
  end
end
