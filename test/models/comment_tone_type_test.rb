# == Schema Information
#
# Table name: comment_tone_types
#
#  id            :integer          not null, primary key
#  tone_text     :string
#  order_in_list :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class CommentToneTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
