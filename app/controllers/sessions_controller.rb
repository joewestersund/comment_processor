class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      if user.active?
        sign_in user
        redirect_to comments_path #root_path
      else
        flash.now[:error] = "This username is currently marked as inactive. Please contact an administrator."
        render 'new'
      end
    else
      flash.now[:error] = "Invalid username / password"
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
