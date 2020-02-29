class AddPushUpdateToRulemaking < ActiveRecord::Migration[5.2]
  def change
    add_column :rulemakings, :allow_push_import, :boolean
  end
end
