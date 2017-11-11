class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.integer :source_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :organization
      t.string :state
      t.string :comment_text
      t.string :attachment_url
      t.string :summary
      t.integer :status_type_id
      t.string :action_needed

      t.timestamps
    end
  end
end
