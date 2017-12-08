module UiHelper
  def assigned_to_css(assigned_to_id)
    if assigned_to_id.nil?
      'not-assigned'
    elsif assigned_to_id == current_user.id
       'assigned-to-me'
    else
      'assigned-to-others'
    end
  end

  def status_css(status_type)
    if status_type.present?
      "status-#{status_type.order_in_list}"
    end
  end

  def highlight_empty_css(text)
    if !text.present?
      'empty'
    end
  end

  def highlight_filled_css(text)
    if text.present?
      'has-content'
    end
  end
end
