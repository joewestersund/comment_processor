class ChangeStatusDetailsToNotesinComments < ActiveRecord::Migration[5.1]
  def change
    rename_column :comments, :status_details, :notes
  end
end
