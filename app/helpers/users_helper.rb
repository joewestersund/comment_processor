module UsersHelper

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
      up = UserPermission.find_by(user: @current_user, rulemaking: @current_user.last_rulemaking_viewed) ||
          UserPermission.find_by(user: @current_user)
      if up.present?
        current_rulemaking = up.rulemaking
      else
        nil
      end
    end
  end

  def permissions_for_current_rulemaking
    UserPermission.find_by(user: @current_user, rulemaking: current_rulemaking)
  end

  def admin_for_current_rulemaking?
    return false if current_rulemaking.nil?
    if current_user.application_admin?
      return true
    else
      up = permissions_for_current_rulemaking
      return up.present? && up.admin?
    end
  end

  def can_edit_current_rulemaking?
    return false if current_rulemaking.nil?
    if current_user.application_admin?
      return true
    else
      up = permissions_for_current_rulemaking
      return up.present? && !up.read_only?
    end
  end

end
