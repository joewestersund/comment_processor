class AddColorNameToDropdownClasses < ActiveRecord::Migration[5.2]
  def change
    add_column :comment_status_types, :color_name, :string
    add_column :suggested_change_status_types, :color_name, :string
    add_column :suggested_change_response_types, :color_name, :string
  end
end
