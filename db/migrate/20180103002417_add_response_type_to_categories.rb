class AddResponseTypeToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :category_response_type_id, :integer
  end
end
