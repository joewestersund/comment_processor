class AddNotesAndTextFromCommentsToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :text_from_comments, :text
    add_column :categories, :notes, :text
  end
end
