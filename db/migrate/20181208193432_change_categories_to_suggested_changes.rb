class ChangeCategoriesToSuggestedChanges < ActiveRecord::Migration[5.1]
  def change

    #remove indices
    remove_index :categories, name: "index_categories_on_rulemaking_and_lowercase_category_name"
    remove_index :categories, name: "index_categories_on_rulemaking_id_and_order_in_list"
    remove_index :change_log_entries, name: "index_cle_on_rulemaking_and_category_and_created_at"

    #remove foreign keys
    remove_foreign_key :categories, :category_status_types
    remove_foreign_key :categories, :category_response_types
    remove_foreign_key :categories, :users, column: :assigned_to_id
    remove_foreign_key :categories, :rulemakings
    remove_foreign_key :category_response_types, :rulemakings
    remove_foreign_key :category_status_types, :rulemakings
    remove_foreign_key :change_log_entries, :categories

    #rename tables and fields
    rename_table :categories, :suggested_changes
    rename_table :category_response_types, :suggested_change_response_types
    rename_table :category_status_types, :suggested_change_status_types

    rename_column :suggested_changes, :category_name, :suggested_change_name
    rename_column :suggested_changes, :category_response_type_id, :suggested_change_response_type_id
    rename_column :suggested_change, :category_status_type_id, :suggested_change_status_type_id

    rename_column :change_log_entries, :category_id, :suggested_change_id

    rename_table :categories_comments, :comments_suggested_changes
    rename_column :comments_suggested_changes, :category_id, :suggested_change_id

    #re-add indices

    add_index :suggested_changes, 'rulemaking_id, lower(suggested_change_name)',
              name: "index_suggested_changes_on_rulemaking_and_suggested_change_name",
              unique: true
    add_index :suggested_changes, [:rulemaking_id, :order_in_list]
    add_index :change_log_entries, [:rulemaking_id,:suggested_change_id, :created_at], name: 'index_cle_on_rulemaking_and_suggested_change_and_created_at'

    add_foreign_key :suggested_changes, :suggested_change_status_types, on_delete: :restrict
    add_foreign_key :suggested_changes, :suggested_change_response_types, on_delete: :nullify
    add_foreign_key :suggested_changes, :users, column: :assigned_to_id, on_delete: :nullify
    add_foreign_key :suggested_changes, :rulemakings, on_delete: :cascade
    add_foreign_key :suggested_change_response_types, :rulemakings, on_delete: :cascade
    add_foreign_key :suggested_change_status_types, :rulemakings, on_delete: :cascade
    add_foreign_key :change_log_entries, :suggested_changes, on_delete: :nullify

  end
end
