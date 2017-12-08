class AddOrderInListToComments < ActiveRecord::Migration[5.1]
  def up
    add_column :comments, :order_in_list, :integer

    #initialize the field
    Comment.order(:id).each_with_index do |c,index|
      c.order_in_list = index + 1
      c.save
    end

  end

  def down
    remove_column :comments, :order_in_list
  end
end
