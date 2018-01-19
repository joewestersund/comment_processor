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

  def admin_user
    redirect_to welcome_path, notice: "That feature is only available to admins." unless current_user.admin
  end

  def not_read_only_user
    redirect_to welcome_path, notice: "That feature is not available to read_only users." if current_user.read_only
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    #don't let inactive users log in.
    @current_user ||= User.find_by(active: true, remember_token: remember_token)

  end
end
