json.extract! comment_data_source, :id, :data_source_name, :string, :description, :comment_download_url, :active, :created_at, :updated_at
json.url comment_data_source_url(comment_data_source, format: :json)
