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

require 'test_helper'

class CategoryResponseTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
