class NotificationMailer < ActionMailer::Base

  default from: 'Comment Processor <westersund.joe@deq.state.or.us>'
  #layout 'mailer'

  def category_assigned_email(category, assigned_by, cc_assigner)

    @category = category
    @category_url  = edit_category_url(@category)
    @assigned_by = assigned_by
    @assigned_to = User.find(@category.assigned_to)

    if cc_assigner && (@assigned_to.email != @assigned_by.email)
      cc = @assigned_by.email_address_with_name
    end

    to = @assigned_to.email_address_with_name

    mail(to: to, cc: cc, subject: "a CAO comment response category has been assigned to you: '#{@category.category_name}'")
  end

end
