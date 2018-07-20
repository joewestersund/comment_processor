class AddRulemakingtoIndices < ActiveRecord::Migration[5.1]
  def up
    add_index :categories, 'rulemaking_id, lower(category_name)',
              name: "index_categories_on_rulemaking_and_lowercase_category_name",
              unique: true

    #for downloading categories to Excel
    add_index :categories, [:rulemaking_id, :order_in_list]

    add_index :change_log_entries, [:rulemaking_id,:category_id, :created_at], name: 'index_cle_on_rulemaking_and_category_and_created_at'
    add_index :change_log_entries, [:rulemaking_id,:comment_id, :created_at], name: 'index_cle_on_rulemaking_and_comment_and_created_at'
    add_index :change_log_entries, [:rulemaking_id, :created_at]
    add_index :change_log_entries, [:rulemaking_id, :user_id]

    #for comments index page, edit page, and downloading to Excel
    add_index :comments, [:rulemaking_id, :comment_data_source_id]
    add_index :comments, [:rulemaking_id, :order_in_list]

    #

    #for categories index page and edit page
    remove_index :categories, name: "index_categories_on_lowercase_category_name"

    #for downloading categories to Excel
    remove_index :categories, :order_in_list

    remove_index :change_log_entries, [:category_id, :created_at]
    remove_index :change_log_entries, [:comment_id, :created_at]
    remove_index :change_log_entries, :created_at
    remove_index :change_log_entries, :user_id

    #for comments index page, edit page, and downloading to Excel
    remove_index :comments, :comment_data_source_id
    remove_index :comments, :order_in_list

  end

  def down
    #for categories index page and edit page
    add_index :categories, 'lower(category_name)',
                 name: "index_categories_on_lowercase_category_name",
                 unique: true

    #for downloading categories to Excel
    add_index :categories, :order_in_list

    add_index :change_log_entries, [:category_id, :created_at]
    add_index :change_log_entries, [:comment_id, :created_at]
    add_index :change_log_entries, :created_at
    add_index :change_log_entries, :user_id

    #for comments index page, edit page, and downloading to Excel
    add_index :comments, :comment_data_source_id
    add_index :comments, :order_in_list

    #

    remove_index :categories, name: "index_categories_on_rulemaking_and_lowercase_category_name"

    #for downloading categories to Excel
    remove_index :categories, [:rulemaking_id, :order_in_list]

    remove_index :change_log_entries, [:rulemaking_id,:category_id, :created_at]
    remove_index :change_log_entries, [:rulemaking_id,:comment_id, :created_at]
    remove_index :change_log_entries, [:rulemaking_id, :created_at]
    remove_index :change_log_entries, [:rulemaking_id, :user_id]

    #for comments index page, edit page, and downloading to Excel
    remove_index :comments, [:rulemaking_id, :comment_data_source_id]
    remove_index :comments, [:rulemaking_id, :order_in_list]
  end
end
