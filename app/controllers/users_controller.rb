class UsersController < ApplicationController
  require 'securerandom'

  include ActionView::Helpers::TextHelper #for the pluralize method

  before_action :signed_in_user, except: [:forgot_password, :send_password_reset_email, :reset_password, :update_password]
  #note: does not require user to have a current rulemaking. That way, app admin user can create the first one.
  before_action :application_admin_user, only: [:edit, :update, :destroy] #only application admin can edit or delete another user
  before_action :admin_user, only: [:new, :create]  #regular admin can create a new user
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :set_self_as_user, only: [:edit_profile, :update_profile, :edit_password]


  # GET /users
  # GET /users.json
  def index
    q = User
    @filtered = false
    if params[:name].present?
      q = q.where("name ILIKE ?", "%#{params[:name]}%")
      @filtered = true
    end
    if params[:email].present?
      q = q.where("email ILIKE ?", "%#{params[:email]}%")
      @filtered = true
    end
    if params[:active].present?
      q = q.where(active: true)
      @filtered = true
    end
    if params[:application_admin].present?
      q = q.where(application_admin: true)
      @filtered = true
    end
    @users = q.order(:name).page(params[:page]).per_page(20)
  end

  # GET /users/new
  def new
    @user = User.new
    @user.active = true #set to active by default
  end

  # GET /users/1/edit
  def edit
  end

  def edit_profile
  end

  def update_profile
    @user.update(update_profile_params)
    if @user.save
      flash[:notice] = 'Your profile was successfully updated.'
      redirect_to profile_edit_path
    else
      render :edit_profile, status: :unprocessable_entity
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if @user.application_admin? && !current_user.application_admin?
      flash[:error] = "Error: since you are not logged in as an application admin user, you can't create a new application admin user."
      render :edit, status: :unprocessable_entity
    else
      #set a random password, but don't tell the user. They'll need to use the token to reset the password.
      random_pw = SecureRandom.hex(8)
      @user.password = random_pw
      @user.password_confirmation = random_pw
      
      # make all email addresses lowercase in the db
      @user.email = @user.email.downcase

      if @user.save
        @user.generate_password_token!

        NotificationMailer.new_user_email(@user,current_user).deliver

        up = UserPermission.new(rulemaking: current_rulemaking, user: @user)
        up.save

        flash[:notice] = "An account for #{@user.name} was successfully created. They have been given permissions to this rulemaking, and a link to log in and set up their password has been emailed to them."
        redirect_to users_path
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.application_admin? && user_params[:application_admin] != '1' && User.where(application_admin: true).count == 1
        flash[:error] = "There must be at least one application admin user."
        format.html { redirect_to users_path }
        format.json { render json: @user.errors, status: "Error: there must be at least one application admin user." }
      elsif !@user.application_admin? && user_params[:application_admin] == '1' && !current_user.application_admin?
        flash[:error] = "Error: since you are not logged in as an application admin user, you can't edit a user to make them an application admin."
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      elsif @user.update(user_params)
        if @user == current_user
          format.html { redirect_to profile_edit_path, notice: 'Your profile was successfully updated.' }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { redirect_to users_path, notice: 'User successfully updated.' }
          format.json { render :show, status: :ok, location: @user }
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def forgot_password
  end

  def send_password_reset_email
    @user = User.find_by(email: params[:email].downcase)
    respond_to do |format|
      if @user.present? && @user.active? && (verify_recaptcha(model: @user) || Rails.env == "development" || Rails.env == "test")
        @user.generate_password_token!
        NotificationMailer.password_reset_email(@user).deliver
        format.html { redirect_to signin_path, notice: "A password reset email has been sent to #{@user.name} at #{@user.email}. Please use the link in that email to reset your password in the next #{pluralize(User.hours_to_reset_password,"hour")}." }
      else
        format.html { redirect_to password_forgot_path, alert: "That email address was not recognized, or the recaptcha was not recognized." }
      end
    end
  end

  def reset_password
    respond_to do |format|
      user = User.find_by(reset_password_token: params[:token]) if !params[:token].blank?
      if user.present? && user.password_token_valid? then
        sign_in user

        # don't erase the password reset token here. Some safelinks programs visit the URL before the user does,
        # so we'll wait until update_password to delete the token.

        #include token parameter in redirect because we need to pass it to a hidden field in the form
        format.html {redirect_to profile_edit_password_path(token: params[:token]), notice: "Please enter a new password"}
      else
        format.html {redirect_to password_forgot_path, alert: "That email address was not recognized, or its password reset link has expired."}
      end
    end
  end

  def update_password
    # user could be signed in and updating their password
    # or they could have clicked a password reset link.
    # Sometimes safelinks programs appear to also click those links, which can log out the user while they're entering a new password.
    # So, we check for the reset password token to be used both here and in :reset_password
    if !signed_in? then
      user = User.find_by(reset_password_token: params[:token]) if !params[:token].blank?
      if user.present? && user.password_token_valid? then
        sign_in user
      else
        redirect_to signin_path, notice: "Please sign in."
        return
      end
    end

    set_self_as_user
    
    respond_to do |format|
      if !params[:user][:password].present?
        
        puts "error updating password. Password cannot be blank."
        @user.errors.add(:base, "Password cannot be blank.")
        format.html { render action: 'edit_password', notice: "Password cannot be blank.", status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }

      elsif @user.update(user_params_change_password)
        
        # erase the password reset token, so (if the user has gotten here through a new user or reset password link)
        # they can't reset it again with that same link
        @user.reset_password_token = nil
        @user.save

        puts "successfully updated password"
        format.html { redirect_to comments_path, notice: 'Your password was successfully updated.' }
        format.json { head :no_content }
      else
        puts "error updating password. #{@user.errors.each {|e| e.to_s}}"
        format.html { render action: 'edit_password', status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    #any suggested changes assigned to this user will be set to assigned_to_id = null automatically by the foreign key constraint.
    respond_to do |format|
      if @user.application_admin? && User.where(application_admin?: true).count == 1
        flash[:error] = "The last application admin user cannot be deleted."
        format.html { redirect_to users_path }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      elsif ChangeLogEntry.where(user: @user).count > 0
        flash[:error] = "This user can't be deleted, because there are one or more change log entries for actions they took. If this user no longer uses the application, try setting them to inactive instead."
        format.html { redirect_to users_path }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      else
        @user.destroy
        format.html { redirect_to users_url, notice: 'User was successfully deleted. Any suggested changes assigned to this user are now assigned to no one.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_self_as_user
      @user = self.current_user
    end

    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :application_admin, :active)
    end

    def update_profile_params
      params.require(:user).permit(:name, :email)
    end

    def user_params_change_password()
      params.require(:user).permit(:password, :password_confirmation)
    end

end
