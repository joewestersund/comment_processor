# == Schema Information
#
# Table name: rulemakings
#
#  id                :bigint           not null, primary key
#  agency            :string
#  allow_push_import :boolean
#  data_changed_at   :datetime
#  rulemaking_name   :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Rulemaking < ApplicationRecord
  has_many :suggested_changes, dependent: :destroy
  has_many :suggested_change_response_types , dependent: :destroy
  has_many :suggested_change_status_types, dependent: :destroy
  has_many :change_log_entries, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :comment_data_sources, dependent: :destroy
  has_many :comment_status_types, dependent: :destroy
  has_many :user_permissions, dependent: :destroy
  has_many :users, foreign_key: :last_rulemaking_viewed_id

  validates :rulemaking_name, presence: true, length: { maximum: 50}, uniqueness: {case_sensitive: false}
  validates :agency, presence: true, length: { maximum: 50}

  # self.X returns data for all rulemakings
  def self.num_attachments
    total = ActiveStorage::Blob.joins(:attachments).
      where(active_storage_attachments: {record_type: "Comment"}).count
    return total
  end
  def self.max_attachment_size
    max = ActiveStorage::Blob.joins(:attachments).
      where(active_storage_attachments: {record_type: "Comment"}).
      maximum(:byte_size)
    if max.nil?
      return 0
    else
      return (max / 1e6).round(1)
    end
  end

  def self.total_attachment_size
    total = ActiveStorage::Blob.joins(:attachments).
      where(active_storage_attachments: {record_type: "Comment"}).
      sum(:byte_size)
    return (total / 1e6).round(1)
  end

  # these return data for a specific rulemaking
  def num_attachments
    total = ActiveStorage::Blob.joins(:attachments).
      where(active_storage_attachments: {record_type: "Comment", record: self.comments}).count
    return total
  end

  def max_attachment_size
    max = ActiveStorage::Blob.joins(:attachments).
      where(active_storage_attachments: {record_type: "Comment", record: self.comments}).maximum(:byte_size)
    if max.nil?
      return 0
    else
      return (max / 1e6).round(1)   #divide by 1e6 to convert to MB
    end
  end

  def total_attachment_size
    total = ActiveStorage::Blob.joins(:attachments).
      where(active_storage_attachments: {record_type: "Comment", record: self.comments}).sum(:byte_size)
    return (total / 1e6).round(1)
  end
  def self.csv_header
    ['ID', 'Rulemaking Name', 'Agency', 'Allow Push Import', 'Data last Updated At', '# of Attachments', 'Max attachment size (MB)', 'Total attachments size (MB)']
  end

  def self.excel_column_widths
    #create array of same length as csv_header, all containing the same initial value
    column_widths = Array.new(User.csv_header.length,:auto)

    #set width of some columns
    #column_widths[Comment.csv_header.index('Comment Text')] = 100
    #column_widths[Comment.csv_header.index('Summary')] = 100
    #column_widths[Comment.csv_header.index('Notes')] = 100

    #return the array
    column_widths
  end

  def to_csv
    [self.id, self.rulemaking_name, self.agency, self.allow_push_import,
     self.data_changed_at.strftime("%F"),
     self.num_attachments, self.max_attachment_size, self.total_attachment_size]
  end
end
