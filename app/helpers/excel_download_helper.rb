module ExcelDownloadHelper

  def excel_download_instructions_link(download_content_type,download_url)
    "#{help_excel_download_instructions_path}?download_content_type=#{download_content_type}&download_url=#{download_url}"
  end

end