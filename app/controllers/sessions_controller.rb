class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      if user.active?
        sign_in user
        if current_rulemaking.present?
          redirect_to comments_path
        elsif user.application_admin? && Rulemaking.count == 0
          #this user is an application admin, and there are no rulemakings set up yet.
          redirect_to rulemakings_path, notice: "Next step: set up a rulemaking"
        else
          redirect_to welcome_path, notice: "This username does not currently have permissions to access any projects. Please contact #{APPLICATION_HOST_NAME} at #{APPLICATION_HOST_EMAIL_ADDRESS}."
        end
      else
        flash.now[:notice] = "This username is currently marked as inactive. Please contact #{APPLICATION_HOST_NAME} at #{APPLICATION_HOST_EMAIL_ADDRESS} if you feel that is in error."
        render 'new', status: :unprocessable_entity
      end
    else
      flash.now[:error] = "Invalid username / password"
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
