module ApplicationHelper

  def rulemaking_data_source
    'https://data.oregon.gov/OData.svc/gvv7-qhw2'
  end


  def full_title(page_title)
    base_title = "Public Comment Review"
    if(page_title.empty?)
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def swap_and_save(first, second)
    temp_value = first.class.maximum(:order_in_list) + 1
    if first.order_in_list > second.order_in_list
      first_new_value = second.order_in_list
      second.order_in_list = first_new_value + 1 #if there's space in between due to deletions, move up
    else
      second.order_in_list = first.order_in_list
      first_new_value = second.order_in_list + 1 #if there's space in between due to deletions, move up
    end
    first.order_in_list = temp_value
    throw "error swapping order_in_list" unless first.save
    throw "error swapping order_in_list" unless second.save
    first.order_in_list = first_new_value
    throw throw "error swapping order_in_list" unless first.save
  end

  def show_boolean(bool_variable)
    return "Y" if bool_variable
    "N"
  end

  def nil_to_zero(variable)
    return variable if variable.present?
    0
  end

  def currency_string_to_number(currency_string)
    #take a string which may be in a currency format, like $12,345.67
    #and convert it to a number.
    currency_string.gsub(/[^\d\.-]/, '') if !currency_string.blank?
  end

  def glyphicon_link(glyphicon_name, alt_text)
    '<i class="glyphicon ' + glyphicon_name + '" title="' + alt_text + '" aria-hidden="true"></i><span class="visible-xs-inline visible-lg-inline nav-text">' + alt_text + '</span><span class="sr-only">' + alt_text + '</span>'
  end

  def set_csv_file_headers
    file_name = "transactions.csv"
    headers["Content-Type"] = "text/csv"
    headers["Content-disposition"] = "attachment; filename=\"#{file_name}\""
  end


  def set_csv_streaming_headers
    #nginx doc: Setting this to "no" will allow unbuffered responses suitable for Comet and HTTP streaming applications
    headers['X-Accel-Buffering'] = 'no'

    headers["Cache-Control"] ||= "no-cache"
    headers.delete("Content-Length")
  end

  def set_currency_styling(number)
    "<span #{'class=negative_number' if number < 0}>#{number_to_currency(number)}</span>".html_safe
  end
end
