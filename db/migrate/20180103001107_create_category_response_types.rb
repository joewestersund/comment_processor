class CreateCategoryResponseTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :category_response_types do |t|
      t.integer :response_text
      t.integer :order_in_list

      t.timestamps
    end
  end
end
