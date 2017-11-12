class CreateCategoryStatusTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :category_status_types do |t|
      t.string :status_text
      t.integer :order_in_list

      t.timestamps
    end
  end
end
