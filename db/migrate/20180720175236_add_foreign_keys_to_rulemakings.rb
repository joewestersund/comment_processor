class AddForeignKeysToRulemakings < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :user_permissions, :users, on_delete: :cascade
    add_foreign_key :user_permissions, :rulemakings, on_delete: :cascade

    add_foreign_key :categories, :rulemakings, on_delete: :cascade
    add_foreign_key :category_response_types, :rulemakings, on_delete: :cascade
    add_foreign_key :category_status_types, :rulemakings, on_delete: :cascade
    add_foreign_key :change_log_entries, :rulemakings, on_delete: :cascade
    add_foreign_key :comments, :rulemakings, on_delete: :cascade
    add_foreign_key :comment_data_sources, :rulemakings, on_delete: :cascade
    add_foreign_key :comment_status_types, :rulemakings, on_delete: :cascade

  end
end
