class ChangeCategoryRuleChangeRequiredToRuleChangeMade < ActiveRecord::Migration[5.1]
  def change
    rename_column :categories, :rule_change_required, :rule_change_made
  end
end
