class RemoveActiveFromRulemaking < ActiveRecord::Migration[5.1]
  def change
    remove_column :rulemakings, :active
  end
end
