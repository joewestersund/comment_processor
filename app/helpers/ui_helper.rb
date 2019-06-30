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

  def format_percent(numerator,denominator,decimal_digits: 0, if_zero_denominator: "-")
    #convert to float in case both arguments are integers. Integer division truncates to an integer.
    if (denominator == 0 or denominator.nil?)
      if_zero_denominator
    else
      "#{(100 * numerator.to_f/denominator).round(decimal_digits)}%"
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

  def highlight_true(boolean_value)
    'highlight-true' if boolean_value
  end

  def show_boolean_value(boolean_value)
    boolean_value ? "Y" : "N"
  end

end
