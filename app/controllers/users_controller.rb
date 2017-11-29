class UsersController < ApplicationController
  before_action :signed_in_user, only: [:new, :edit, :edit_profile, :edit_password, :update, :update_password, :show, :destroy, :index]
  before_action :admin_user, only: [:new, :edit, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_self_as_user, only: [:edit_profile, :edit_password, :update_password]


  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  def edit_profile
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params_new)
    if @user.save
      sign_in @user
      flash[:notice] = "User has been added."
      redirect_to welcome_path
    else
      render 'new'
    end
  end


  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to profile_edit_path, notice: 'User successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_password
    respond_to do |format|
      if params[:user][:password].present? and @user.update(user_params_change_password)
        format.html { redirect_to profile_edit_password_path, notice: 'Your password was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit_password' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_self_as_user
      @user = self.current_user
      #@user = User.find(params[:id])
    end

    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :admin)
    end

    def user_params_new
      params.require(:user).permit(:name, :email, :admin, :password, :password_confirmation)
    end

    def user_params_change_password()
      params.require(:user).permit(:password, :password_confirmation)
    end


end
