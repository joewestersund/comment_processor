class NotificationMailer < ActionMailer::Base
  before_action :set_contact_msg

  default from: "#{APPLICATION_NAME} <#{APPLICATION_EMAIL_ADDRESS}>"

  def suggested_change_assigned_email(suggested_change, assigned_by, cc_assigner)

    @suggested_change = suggested_change
    @suggested_change_url  = edit_suggested_change_url(@suggested_change)
    @assigned_by = assigned_by
    @assigned_to = @suggested_change.assigned_to

    if cc_assigner && (@assigned_to.email != @assigned_by.email)
      cc = @assigned_by.email_address_with_name
    end

    to = @assigned_to.email_address_with_name

    mail(to: to, cc: cc, subject: "a suggested_change has been assigned to you: '#{@suggested_change.suggested_change_name}'")
  end

  def password_reset_email(user)
    @user = user
    @url = "#{Rails.configuration.action_mailer.default_url_options[:host]}/password/reset/#{@user.reset_password_token}"
    @hours_to_reset_password = User.hours_to_reset_password

    to = @user.email_address_with_name
    cc = nil
    mail(to: to, cc: cc, subject: "Link to reset your password for the #{APPLICATION_NAME} website")

  end

  def new_user_email(new_user,added_by)
    @new_user = new_user
    @added_by  = added_by
    @main_app_url = "#{Rails.configuration.action_mailer.default_url_options[:host]}"
    @password_reset_url = "#{Rails.configuration.action_mailer.default_url_options[:host]}/password/reset/#{@new_user.reset_password_token}"
    @hours_to_log_in = User.hours_to_do_first_login

    cc = @added_by.email_address_with_name
    to = @new_user.email_address_with_name
    bcc = APPLICATION_EMAIL_ADDRESS

    mail(to: to, cc: cc, bcc: bcc, subject: "A login for the #{APPLICATION_NAME} website has been created for you")

  end

  private

  def set_contact_msg()
    @contact_if_questions_msg = "#{APPLICATION_NAME} is a website for collaborating on responding to public comments. " +
      "If you have questions about the application or this email, please contact #{APPLICATION_ADMIN_NAME} " +
      "at #{APPLICATION_ADMIN_EMAIL} or #{APPLICATION_ADMIN_PHONE}. Thank you!"
  end
end
