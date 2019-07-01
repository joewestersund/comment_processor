class HelpController < ApplicationController

  def excel_download_instructions
    @download_url = params[:download_url]
    @download_content_type = params[:download_content_type]
  end

end