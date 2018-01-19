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
      css_order_in_list('status',status_type.order_in_list)
    end
  end

  def response_css(response_type)
    if response_type.present?
      css_order_in_list('response',response_type.order_in_list)
    end
  end

  def css_order_in_list(prefix,order_in_list)
    "#{prefix}-#{order_in_list}"
  end

  def format_percent(numerator,denominator,decimal_digits = 0)
    #convert to float in case both arguments are integers. Integer division truncates to an integer.
    "#{(100 * numerator.to_f/denominator).round(decimal_digits)}%"
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

  def highlight_true(boolean_value)
    'highlight-true' if boolean_value
  end

  def show_boolean_value(boolean_value)
    boolean_value ? "Y" : "N"
  end

end
