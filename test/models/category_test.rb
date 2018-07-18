# == Schema Information
#
# Table name: categories
#
#  id                        :integer          not null, primary key
#  category_name             :text
#  description               :text
#  response_text             :text
#  assigned_to_id            :integer
#  category_status_type_id   :integer
#  action_needed             :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  order_in_list             :integer
#  rule_change_made          :boolean
#  category_response_type_id :integer
#  text_from_comments        :text
#  notes                     :text
#  rulemaking_id             :integer
#

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
