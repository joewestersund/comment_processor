# == Schema Information
#
# Table name: comments
#
#  id                     :bigint           not null, primary key
#  attachment_name        :string
#  attachment_url         :string
#  comment_text           :text
#  email                  :string
#  first_name             :string
#  last_name              :string
#  manually_entered       :boolean
#  notes                  :text
#  num_commenters         :integer
#  order_in_list          :integer
#  organization           :string
#  state                  :string
#  summary                :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  comment_data_source_id :integer
#  comment_status_type_id :integer
#  rulemaking_id          :integer
#  source_id              :integer
#
# Indexes
#
#  index_comments_on_rulemaking_id_and_comment_data_source_id  (rulemaking_id,comment_data_source_id)
#  index_comments_on_rulemaking_id_and_order_in_list           (rulemaking_id,order_in_list)
#
# Foreign Keys
#
#  fk_rails_...  (comment_data_source_id => comment_data_sources.id) ON DELETE => nullify
#  fk_rails_...  (comment_status_type_id => comment_status_types.id) ON DELETE => restrict
#  fk_rails_...  (rulemaking_id => rulemakings.id) ON DELETE => cascade
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
