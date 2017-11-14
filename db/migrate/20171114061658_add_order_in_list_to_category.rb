class AddOrderInListToCategory < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :order_in_list, :integer
  end
end
