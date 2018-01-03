class FixCategoryResponseTypeColumnType < ActiveRecord::Migration[5.1]
  def up
    change_column :category_response_types, :response_text, :string
  end

  def down
    change_column :category_response_types, :response_text, :integer
  end
end
