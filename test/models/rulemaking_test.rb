# == Schema Information
#
# Table name: rulemakings
#
#  id                                 :integer          not null, primary key
#  rulemaking_name                    :string
#  agency                             :string
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  open_for_public_to_submit_comments :boolean
#  open_for_public_to_view_comments   :boolean
#

require 'test_helper'

class RulemakingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
