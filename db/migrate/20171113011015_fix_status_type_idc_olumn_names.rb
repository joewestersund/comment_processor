class FixStatusTypeIdcOlumnNames < ActiveRecord::Migration[5.1]
  def change
    rename_column :comments, :status_type_id, :comment_status_type_id
    rename_column :categories, :status_type_id, :category_status_type_id
  end
end
