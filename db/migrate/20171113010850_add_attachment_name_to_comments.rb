class AddAttachmentNameToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :attachment_name, :string
  end
end
