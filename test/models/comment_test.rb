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
#  notes                  :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  attachment_name        :string
#  manually_entered       :boolean
#  order_in_list          :integer
#  num_commenters         :integer
#

require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  test "displays name even if no email address" do
    comment = Comment.new(first_name: 'Joe', last_name: 'Westersund', comment_text: 'test')
    assert comment.name_and_email == 'Joe Westersund'
  end

  test "displays email even if no name" do
    comment = Comment.new(email: 'test@test.com', comment_text: 'test')
    assert comment.name_and_email == '<test@test.com>'
  end

  test "displays name and email" do
    comment = Comment.new(first_name: 'Joe', email: 'test@test.com', comment_text: 'test')
    assert comment.name_and_email == 'Joe <test@test.com>'
  end

end
