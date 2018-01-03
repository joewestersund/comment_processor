class AddNumCommentersToComments < ActiveRecord::Migration[5.1]
  def up
    add_column :comments, :num_commenters, :integer

    execute "UPDATE Comments SET num_commenters = 1"
  end

  def down
    remove_column :comments, :num_commenters
  end
end
