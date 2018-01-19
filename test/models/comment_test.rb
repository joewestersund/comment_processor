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
#  comment_text           :text
#  attachment_url         :string
#  summary                :text
#  comment_status_type_id :integer
#  status_details         :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  attachment_name        :string
#  manually_entered       :boolean
#  order_in_list          :integer
#  num_commenters         :integer
#

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
