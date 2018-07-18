# == Schema Information
#
# Table name: user_permissions
#
#  id            :integer          not null, primary key
#  admin         :boolean
#  read_only     :boolean
#  user_id       :integer
#  rulemaking_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class UserPermissionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
