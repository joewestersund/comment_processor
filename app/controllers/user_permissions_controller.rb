class UserPermissionsController < ApplicationController

  before_action :signed_in_user
  before_action :user_with_permissions_to_a_rulemaking
  before_action :admin_user, except: [:index]
  before_action :set_user_permission, only: [:edit, :update, :destroy]
  before_action :set_select_options, only: [:new, :edit ]

  # GET /user_permissions
  # GET /user_permissions.json
  def index
    @user_permissions = current_rulemaking.user_permissions.includes(:user).order("users.name").page(params[:page]).per_page(20)
  end

  # GET /user_permissions/new
  def new
    @user_permission = UserPermission.new
    @user_permission.rulemaking = current_rulemaking
  end

  # GET /user_permissions/1/edit
  def edit
  end

  # POST /user_permissions
  # POST /user_permissions.json
  def create
    @user_permission = UserPermission.new(user_permission_params)
    @user_permission.rulemaking = current_rulemaking

    respond_to do |format|
      if @user_permission.save
        format.html { redirect_to user_permissions_url, notice: 'User permission was successfully created.' }
        format.json { render :show, status: :created, location: @user_permission }
      else
        set_select_options
        format.html { render :new }
        format.json { render json: @user_permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_permissions/1
  # PATCH/PUT /user_permissions/1.json
  def update
    respond_to do |format|
      result = @user_permission.update(user_permission_params)
      if result
        format.html { redirect_to user_permissions_url, notice: 'User permission was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_permission }
      else
        set_select_options
        format.html { render :edit }
        format.json { render json: @user_permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_permissions/1
  # DELETE /user_permissions/1.json
  def destroy
    current_rulemaking.suggested_changes.where(user: @user_permission.user).each do |sc|
      sc.assigned_to_id = nil
      sc.save
    end

    @user_permission.destroy
    respond_to do |format|
      format.html { redirect_to user_permissions_url, notice: 'This user permission was successfully deleted. All suggested changes for this rulemaking that were assigned to this user are now assigned to no one.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_permission
      @user_permission = UserPermission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_permission_params
      p = params.require(:user_permission).permit(:user_id)
      p = p.merge(admin: (permission_type_param[:permission_type] == "admin"))
      p = p.merge(read_only: (permission_type_param[:permission_type] == "read only"))
      p
    end

    def permission_type_param
      params.require(:user_permission).permit(:permission_type)
    end

    def set_select_options
      #need to include all users, not just those that already have permissions for this rulemaking.
      @users = User.order(:name).all
    end

end
