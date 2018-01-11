class NotificationMailer < ActionMailer::Base

  default from: 'Comment Processor <westersund.joe@deq.state.or.us>'
  #layout 'mailer'

  def category_assigned_email(category, assigned_by, cc_assigner)

    @category = category
    @category_url  = edit_category_url(@category)
    @assigned_by = assigned_by
    @assigned_to = @category.assigned_to

    if cc_assigner && (@assigned_to.email != @assigned_by.email)
      cc = @assigned_by.email_address_with_name
    end

    to = @assigned_to.email_address_with_name

    mail(to: to, cc: cc, subject: "a CAO comment response category has been assigned to you: '#{@category.category_name}'")
  end

  def password_reset_email(user_to_reset,reset_by,new_pw)
    @user_to_reset = user_to_reset
    @reset_by  = reset_by
    @new_password = new_pw
    @url = signin_url

    cc = @reset_by.email_address_with_name
    to = @user_to_reset.email_address_with_name

    mail(to: to, cc: cc, subject: 'Your login for the CAO comment response software has been reset')

  end

  def new_user_email(new_user,added_by,new_pw)
    @new_user = new_user
    @added_by  = added_by
    @new_password = new_pw
    @url = signin_url

    cc = @added_by.email_address_with_name
    to = @new_user.email_address_with_name

    mail(to: to, cc: cc, subject: 'A login for the CAO comment response website has been created for you')

  end

end
