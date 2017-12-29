class AddRulesChangeToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :rule_change_required, :boolean
  end
end
