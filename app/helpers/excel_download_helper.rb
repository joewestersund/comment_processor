module ExcelDownloadHelper

  def excel_download_instructions_link(klass,querystring)
    "#{help_excel_download_instructions_path}?object_type=#{klass.name}&#{querystring.to_query}"
  end

  def excel_download_path(class_name,querystring)
    if class_name == 'Comment'
      download_link = comments_path(format: "xlsx") + "?#{querystring.to_query}"
    elsif class_name == 'SuggestedChange'
      download_link = suggested_changes_path(format: "xlsx") + "?#{querystring.to_query}"
    else
      raise "Error: unknown class '#{class_name}' passed to excel_download_path."
    end
    download_link
  end

end