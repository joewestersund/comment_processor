json.extract! category, :id, :category_name, :description, :response_text, :response_by, :status_type_id, :action_needed, :rule_change_required, :created_at, :updated_at
json.url category_url(category, format: :json)
