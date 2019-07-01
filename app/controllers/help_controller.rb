class HelpController < ApplicationController

  def excel_download_instructions
    @object_type = params[:object_type]
    @download_content_type = (@object_type == "Comment" ? "Comments" : "Suggested Changes")
    @filter_querystring = excel_download_filter_params(@object_type)
  end

  private

  def excel_download_filter_params(class_name)
    if class_name == "Comment"
      #from comments_controller.rb filter_params_all
      params.permit(:first_name, :last_name, :email, :organization, :state, :comment_text, :summary, :comment_status_type_id, :notes, :manually_entered, :comment_data_source_id, :has_attachment, :suggested_change_id, )
    elsif class_name == "SuggestedChange"
      #from suggested_changes_controller.rb filter_params
      params.permit(:suggested_change_name, :description, :response_text, :assigned_to_id, :suggested_change_status_type_id, :suggested_change_response_type_id, :action_needed, :rule_change_made, :notes, :text_from_comments)
    else
      raise "incorrect class_name '#{class_name}' passed to excel_download_filter_params"
    end

  end

end