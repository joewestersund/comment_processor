# == Schema Information
#
# Table name: suggested_changes
#
#  id                                :integer          not null, primary key
#  suggested_change_name             :text
#  description                       :text
#  response_text                     :text
#  assigned_to_id                    :integer
#  suggested_change_status_type_id   :integer
#  action_needed                     :text
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  order_in_list                     :integer
#  rule_change_made                  :boolean
#  suggested_change_response_type_id :integer
#  text_from_comments                :text
#  notes                             :text
#  rulemaking_id                     :integer
#

class SuggestedChange < ApplicationRecord
  has_and_belongs_to_many :comments
  has_many :change_log_entries
  belongs_to :rulemaking
  belongs_to :suggested_change_status_type
  belongs_to :suggested_change_response_type, optional: true
  belongs_to :user, foreign_key: 'assigned_to_id', optional: true

  validates :suggested_change_name, presence: true, uniqueness: { case_sensitive: false, scope: :rulemaking_id }
  validates :order_in_list, numericality: { only_integer: true, greater_than: 0}, uniqueness: {scope: :rulemaking_id }

  def self.csv_header
    ['Order In List', 'Suggested Change Name', 'Description', 'Response Text', 'Response Type', 'Assigned To',
     'Status', 'Action Needed', 'Rule Change Made', 'Comments (by their "order in list")', '# of Comments', '# of Commenters', 'ID', 'Text from Comments', 'Notes']
  end

  def self.excel_column_widths
    #create array of same length as csv_header, all containing the same initial value
    column_widths = Array.new(SuggestedChange.csv_header.length,:auto)

    #set column widths for some columns
    column_widths[SuggestedChange.csv_header.index('Description')] = 100
    column_widths[SuggestedChange.csv_header.index('Response Text')] = 100
    column_widths[SuggestedChange.csv_header.index('Text from Comments')] = 100
    column_widths[SuggestedChange.csv_header.index('Notes')] = 100

    #return the array
    column_widths
  end

  def assigned_to
    if self.assigned_to_id.present?
      User.find(self.assigned_to_id)
    else
      nil
    end
  end

  def assigned_to_name
    if self.assigned_to_id.present?
      User.find(self.assigned_to_id).name
    else
      nil
    end
  end

  def num_comments
    self.comments.count
  end

  def num_commenters
    self.comments.sum(:num_commenters)
  end

  def to_csv
    [self.order_in_list, self.suggested_change_name, self.description, self.response_text,
     self.suggested_change_response_type.present? ? self.suggested_change_response_type.response_text : '',
     self.assigned_to_id.present? ? self.assigned_to.name : '',
     self.suggested_change_status_type.present? ? self.suggested_change_status_type.status_text : '',
     self.action_needed, self.rule_change_made, self.comments.order(:source_id).collect{|com| com.order_in_list}.join(", "),
     self.num_comments, self.num_commenters, self.id, remove_html(self.text_from_comments).to_s.truncate(1000), remove_html(self.notes).to_s.truncate(1000)]
  end

  def preview_merge(merge_from_suggested_change)
    return merge_suggested_change_fields(merge_from_suggested_change,self.duplicate)
  end

  def duplicate
    duplicate_copy = self.dup
    duplicate_copy.comments << self.comments
    duplicate_copy
  end

  private

  def get_merged_text(current_text, text_to_add,delimiter,options={})
    if text_to_add.to_s.empty?
      current_text
    elsif current_text.to_s.empty?
      text_to_add
    else
      if options[:multiline] && options[:html]
        "#{current_text}<br>#{delimiter}<br>#{text_to_add}"
      elsif options[:multiline]
        "#{current_text}\n#{delimiter}\n#{text_to_add}"
      else
        "#{current_text}#{delimiter}#{text_to_add}"
      end
    end
  end

  def merge_suggested_change_fields(from_suggested_change, to_suggested_change)
    multiline_delimiter = "[merged from suggested_change '#{from_suggested_change.suggested_change_name}']"
    short_delimiter = " | "

    #copy over any new comments. Don't copy if a comment is already in to_suggested_change
    to_suggested_change.comments << (from_suggested_change.comments - to_suggested_change.comments)

    to_suggested_change.text_from_comments = get_merged_text(to_suggested_change.text_from_comments,from_suggested_change.text_from_comments,multiline_delimiter, {multiline:true, html:true})
    to_suggested_change.description = get_merged_text(to_suggested_change.description,from_suggested_change.description,multiline_delimiter, {multiline:true})
    to_suggested_change.response_text = get_merged_text(to_suggested_change.response_text,from_suggested_change.response_text,multiline_delimiter, {multiline:true})
    to_suggested_change.action_needed = get_merged_text(to_suggested_change.action_needed,from_suggested_change.action_needed,short_delimiter)
    to_suggested_change.notes = get_merged_text(to_suggested_change.notes,from_suggested_change.notes,multiline_delimiter, {multiline:true, html:true})

    return to_suggested_change
  end


end
