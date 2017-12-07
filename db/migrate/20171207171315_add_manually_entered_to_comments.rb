class AddManuallyEnteredToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :manually_entered, :boolean
  end
end
