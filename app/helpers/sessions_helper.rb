module SessionsHelper
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def signed_in_user
    redirect_to signin_path, notice: "Please sign in." unless signed_in?
  end

  def user_with_permissions_to_a_rulemaking
    redirect_to welcome_path, notice: "This username does not currently have permissions to access any projects." unless current_rulemaking.present?
  end

  def application_admin_user
    redirect_to welcome_path, notice: "That feature is only available to application admins." unless current_user.application_admin?
  end

  def admin_user
    redirect_to welcome_path, notice: "That feature is only available to admins." unless current_user.admin_for?(current_rulemaking)
  end

  def not_read_only_user
    redirect_to welcome_path, notice: "That feature is not available to read_only users." unless current_user.can_edit?(current_rulemaking)
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    #don't let inactive users log in.
    @current_user ||= User.find_by(active: true, remember_token: remember_token)

  end

  def set_current_rulemaking(rulemaking)
    if rulemaking.present? && (@current_user.user_permissions.find_by(rulemaking: rulemaking) || @current_user.application_admin?) then
      @current_rulemaking = rulemaking
      @current_user.last_rulemaking_viewed_id = rulemaking.id
      @current_user.save! #save this to the db
      @current_rulemaking #return this value
    else
      nil #return this value
    end

  end

  def current_rulemaking
    if @current_rulemaking.present?
      @current_rulemaking
    else
      up = current_user.user_permissions.find_by(rulemaking: current_user.last_rulemaking_viewed)
      if up.present?
        @current_rulemaking = up.rulemaking
      elsif @current_user.user_permissions.first
        #last_rulemaking_viewed is blank, so just pick the first one they have permissions to
        set_current_rulemaking(@current_user.user_permissions.first.rulemaking)
        @current_rulemaking #return this value
      elsif @current_user.application_admin? && Rulemaking.count > 0 #application admin user that has no permissions, can still see all rulemakings
        r = Rulemaking.find(current_user.last_rulemaking_viewed_id) if current_user.last_rulemaking_viewed_id.present?
        r = Rulemaking.first unless r.present?
        set_current_rulemaking(r)
        @current_rulemaking #return this value
      else
        #this user does not have permissions to any rulemakings
        nil
      end
    end
  end
end
