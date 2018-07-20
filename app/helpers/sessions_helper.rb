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

  def current_rulemaking=(rulemaking)
    if rulemaking.present? && @current_user.user_permissions.find_by(rulemaking_id: rulemaking) then
      @current_rulemaking = rulemaking
      @current_user.last_rulemaking_viewed = rulemaking
    end

  end

  def current_rulemaking
    if @current_rulemaking.present?
      @current_rulemaking
    else
      up = UserPermission.find_by(user: current_user, rulemaking: current_user.last_rulemaking_viewed) ||
          UserPermission.find_by(user: current_user)
      if up.present?
        @current_rulemaking = up.rulemaking
      else
        nil
      end
    end
  end
end
