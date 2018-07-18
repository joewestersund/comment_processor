# == Schema Information
#
# Table name: category_response_types
#
#  id            :integer          not null, primary key
#  response_text :string
#  order_in_list :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  rulemaking_id :integer
#

class CategoryResponseType < ApplicationRecord
  belongs_to :rulemaking
  has_many :categories

  validates :response_text, presence: true, uniqueness: { case_sensitive: false }
  validates :order_in_list, numericality: { only_integer: true, greater_than: 0}, uniqueness: true

end
