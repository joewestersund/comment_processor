json.extract! category, :id, :category_name, :summary, :response_text, :response_by, :status_type_id, :action_needed, :created_at, :updated_at
json.url category_url(category, format: :json)
