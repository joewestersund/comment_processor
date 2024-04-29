# == Schema Information
#
# Table name: rulemakings
#
#  id                :bigint           not null, primary key
#  agency            :string
#  allow_push_import :boolean
#  data_changed_at   :datetime
#  rulemaking_name   :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'test_helper'

class RulemakingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
