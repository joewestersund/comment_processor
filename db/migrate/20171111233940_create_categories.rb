class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string :category_name
      t.string :summary
      t.string :response_text
      t.integer :response_by
      t.integer :status_type_id
      t.string :action_needed

      t.timestamps
    end
  end
end
