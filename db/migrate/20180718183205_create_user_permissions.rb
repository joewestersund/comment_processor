class CreateUserPermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :user_permissions do |t|
      t.boolean :admin
      t.boolean :read_only
      t.integer :user_id
      t.integer :rulemaking_id

      t.timestamps
    end
  end
end
