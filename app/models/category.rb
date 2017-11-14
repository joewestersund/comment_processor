# == Schema Information
#
# Table name: categories
#
#  id                      :integer          not null, primary key
#  category_name           :string
#  summary                 :string
#  response_text           :string
#  response_by             :integer
#  category_status_type_id :integer
#  action_needed           :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  order_in_list           :integer
#

class Category < ApplicationRecord
  has_and_belongs_to_many :comments
  belongs_to :category_status_type
end
