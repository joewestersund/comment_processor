# == Schema Information
#
# Table name: category_status_types
#
#  id            :integer          not null, primary key
#  status_text   :string
#  order_in_list :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class CategoryStatusType < ApplicationRecord
  has_many :categories

  validates :status_text, presence: true, uniqueness: { case_sensitive: false }
  validates :order_in_list, numericality: { only_integer: true, greater_than: 0}, uniqueness: true

end
