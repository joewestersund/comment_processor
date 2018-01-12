class AddDatabaseIndexes < ActiveRecord::Migration[5.1]
  def change
    #for comments index page, edit page, and downloading to Excel
    add_index :comments, :order_in_list

    #for categories index page and edit page
    add_index :categories, 'lower(category_name)',
              name: "index_categories_on_lowercase_category_name",
              unique: true

    #for downloading categories to Excel
    add_index :categories, :order_in_list

  end
end
