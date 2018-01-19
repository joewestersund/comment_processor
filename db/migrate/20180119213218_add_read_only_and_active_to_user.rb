class AddReadOnlyAndActiveToUser < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :active, :boolean
    add_column :users, :read_only, :boolean

    #by default set active to true
    execute "UPDATE Users SET active = true"
  end

  def down
    remove_column :users, :active
    remove_column :users, :read_only
  end
end
