json.extract! comment, :id, :source_id, :first_name, :last_name, :email, :organization, :state, :comment_text, :attachment_url, :summary, :status_type_id, :action_needed, :created_at, :updated_at
json.url comment_url(comment, format: :json)
