# == Schema Information
#
# Table name: comments
#
#  id                     :integer          not null, primary key
#  source_id              :integer
#  first_name             :string
#  last_name              :string
#  email                  :string
#  organization           :string
#  state                  :string
#  comment_text           :string
#  attachment_url         :string
#  summary                :string
#  comment_status_type_id :integer
#  action_needed          :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  attachment_name        :string
#

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
