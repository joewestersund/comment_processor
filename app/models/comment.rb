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
#  manually_entered       :boolean
#

class Comment < ApplicationRecord
  has_and_belongs_to_many :categories
  belongs_to :comment_status_type

  def self.csv_header
    ['# In List', 'ID', 'Source ID', 'First Name', 'Last Name', 'Email',
     'Organization', 'State', 'Comment Text', 'Attachment Name', 'Attachment URL', 'Manually Entered?',
     'Summary','Categories (by their "order in list")','Status','Action Needed']
  end

  def to_csv(index)
    #assumes index is zero-based, so adds 1.
    [index+1,self.id, self.source_id, self.first_name, self.last_name, self.email,
     self.organization, self.state, self.comment_text, self.attachment_name, self.attachment_url, self.manually_entered,
     self.summary, self.categories.order(:order_in_list).collect{|cat| cat.order_in_list}.join(", "), self.comment_status_type.status_text, self.action_needed]
  end

end
