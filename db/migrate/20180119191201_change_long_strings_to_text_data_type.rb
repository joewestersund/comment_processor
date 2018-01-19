class ChangeLongStringsToTextDataType < ActiveRecord::Migration[5.1]
  def up
    change_column :categories, :category_name, :text
    change_column :categories, :description, :text
    change_column :categories, :response_text, :text
    change_column :categories, :action_needed, :text

    change_column :comments, :comment_text, :text
    change_column :comments, :summary, :text
    change_column :comments, :status_details, :text
  end

  def down
    change_column :categories, :category_name, :string
    change_column :categories, :description, :string
    change_column :categories, :response_text, :string
    change_column :categories, :action_needed, :string

    change_column :comments, :comment_text, :string
    change_column :comments, :summary, :string
    change_column :comments, :status_details, :string
  end
end