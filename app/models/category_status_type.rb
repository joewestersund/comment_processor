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
end
