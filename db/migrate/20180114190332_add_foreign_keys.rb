class AddForeignKeys < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :categories, :category_status_types, on_delete: :restrict

    add_foreign_key :categories, :category_response_types, on_delete: :nullify
    add_foreign_key :categories, :users, column: :assigned_to_id, on_delete: :nullify

    add_foreign_key :comments, :comment_status_types, on_delete: :restrict

  end
end
