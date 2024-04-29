# == Schema Information
#
# Table name: comment_status_types
#
#  id            :bigint           not null, primary key
#  color_name    :string
#  order_in_list :integer
#  status_text   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  rulemaking_id :integer
#
# Foreign Keys
#
#  fk_rails_...  (rulemaking_id => rulemakings.id) ON DELETE => cascade
#

require 'test_helper'

class CommentStatusTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
