json.extract! user_permission, :id, :admin, :read_only, :user_id, :rulemaking_id, :created_at, :updated_at
json.url user_permission_url(user_permission, format: :json)
