include ApplicationHelper
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

class Comment < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :change_log_entries
  belongs_to :comment_status_type

  validates :num_commenters, presence: true, numericality: { only_integer: true, greater_than: 0}


  def self.csv_header
    ['Order In List', 'DAS ID', 'First Name', 'Last Name', 'Email',
     'Organization', 'State', 'Comment Text', 'Attachment Name', 'Attachment URL', 'Manually Entered?',
     'Num Commenters','Summary','Status','Status Details','Categories (by their "order in list")', 'ID']
  end

  def self.excel_column_widths
    #create array of same length as csv_header, all containing the same initial value
    column_widths = Array.new(Comment.csv_header.length,:auto)
    #set width of 'Comment Text' column to 100
    column_widths[7] = 100

    #return the array
    column_widths
  end

  def to_csv
    status = self.comment_status_type.present? ? self.comment_status_type.status_text : nil
    categories = self.categories.order(:order_in_list).collect{|cat| cat.order_in_list}.join(", ")

    [self.order_in_list, self.source_id, self.first_name, self.last_name, self.email,
     self.organization, self.state, self.comment_text, self.attachment_name, self.attachment_url, self.manually_entered, self.num_commenters,
     self.summary, status, self.status_details, categories, self.id]
  end

  def name_and_email
    str = join_without_blanks([self.first_name,self.last_name], ' ')
    str += " <#{self.email}>" if self.email.present?
  end

  def key_info
    name_str = join_without_blanks([self.first_name,self.last_name], ' ')
    org_str = join_without_blanks([self.organization,self.state], ', ')

    "##{self.order_in_list} #{name_str} (#{org_str})"
  end

end
