include ApplicationHelper

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

class Comment < ApplicationRecord
  has_many_attached :attached_files

  has_and_belongs_to_many :suggested_changes
  has_many :change_log_entries
  belongs_to :rulemaking
  belongs_to :comment_status_type
  belongs_to :comment_data_source, optional: true


  validates :num_commenters, presence: true, numericality: { only_integer: true, greater_than: 0}
  validates :order_in_list, numericality: { only_integer: true, greater_than: 0}, uniqueness: {scope: :rulemaking_id }

  def self.csv_header
    ['Order In List', 'Comment Data Source', 'DAS ID', 'First Name', 'Last Name', 'Email',
     'Organization', 'State', 'Comment Text', 'Attachment Name', 'Attachment URL', 'Attached Files', 'Manually Entered?',
     'Num Commenters','Summary','Status','Notes','Suggested Changes (by their "order in list")', 'ID']
  end

  def self.excel_column_widths
    #create array of same length as csv_header, all containing the same initial value
    column_widths = Array.new(Comment.csv_header.length,:auto)

    #set width of some columns
    column_widths[Comment.csv_header.index('Comment Text')] = 100
    column_widths[Comment.csv_header.index('Summary')] = 100
    column_widths[Comment.csv_header.index('Notes')] = 100

    #return the array
    column_widths
  end

  def to_csv
    status = self.comment_status_type.present? ? self.comment_status_type.status_text : nil
    suggested_changes = self.suggested_changes.order(:order_in_list).collect{|sc| sc.order_in_list}.join(", ")

    host_str = Rails.application.routes.default_url_options[:host]
    attachment_list_string = self.attached_files.map{ |af| "#{host_str}/comments/#{self.id}/attached_file/#{af.id}" }.join(', ')

    data_source_name = self.comment_data_source.data_source_name if self.comment_data_source.present?

    [self.order_in_list, data_source_name, self.source_id, self.first_name, self.last_name, self.email,
     self.organization, self.state, self.comment_text, self.attachment_name, self.attachment_url, attachment_list_string, self.manually_entered, self.num_commenters,
     self.summary, status, remove_html(self.notes).to_s.truncate(1000), suggested_changes, self.id]
  end

  def name_and_email
    str = join_without_blanks([self.first_name,self.last_name], ' ')
    str = join_without_blanks([str,"<#{self.email}>"], ' ') if self.email.present?
    return str
  end

  def key_info
    info = "##{self.order_in_list}"
    name_str = join_without_blanks([self.first_name,self.last_name], ' ')
    org_str = join_without_blanks([self.organization], ', ')

    if name_str.blank?
      info += " #{org_str}" if !org_str.blank?  #no parentheses around org
    else
      info += " #{name_str}"
      info += " (#{org_str})" if !org_str.blank? #parentheses around org
    end

    info
  end

end
