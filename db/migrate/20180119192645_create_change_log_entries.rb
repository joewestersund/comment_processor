class CreateChangeLogEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :change_log_entries do |t|
      t.text :description
      t.integer :comment_id
      t.integer :category_id
      t.integer :user_id

      t.timestamps
    end
  end
end
