# == Schema Information
#
# Table name: change_log_entries
#
#  id          :integer          not null, primary key
#  description :text
#  comment_id  :integer
#  category_id :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class ChangeLogEntryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
