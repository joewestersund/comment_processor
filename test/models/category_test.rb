# == Schema Information
#
# Table name: categories
#
#  id                      :integer          not null, primary key
#  category_name           :string
#  description             :string
#  response_text           :string
#  assigned_to             :integer
#  category_status_type_id :integer
#  action_needed           :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  order_in_list           :integer
#  rule_change_required    :boolean
#

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
