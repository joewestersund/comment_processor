# == Schema Information
#
# Table name: categories
#
#  id                        :integer          not null, primary key
#  category_name             :string
#  description               :string
#  response_text             :string
#  assigned_to_id            :integer
#  category_status_type_id   :integer
#  action_needed             :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  order_in_list             :integer
#  rule_change_made          :boolean
#  category_response_type_id :integer
#

class Category < ApplicationRecord
  has_and_belongs_to_many :comments
  belongs_to :category_status_type
  belongs_to :category_response_type, optional: true
  belongs_to :user, foreign_key: 'assigned_to_id', optional: true

  validates :category_name, presence: true, uniqueness: { case_sensitive: false }
  validates :order_in_list, numericality: { only_integer: true, greater_than: 0}, uniqueness: true

  def self.csv_header
    ['Order In List', 'Category Name', 'Description', 'Response Text', 'Response Type', 'Assigned To',
     'Status', 'Action Needed', 'Rule Change Made', 'Comments (by their "order in list")', '# of Comments', '# of Commenters']
  end

  def self.excel_column_widths
    #create array of same length as csv_header, all containing the same initial value
    column_widths = Array.new(Category.csv_header.length,:auto)
    #set width of 'Description' and 'Response Text' columns to 100
    column_widths[2] = 100
    column_widths[3] = 100

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

  def num_comments
    self.comments.count
  end

  def num_commenters
    self.comments.sum(:num_commenters)
  end

  def to_csv
    [self.order_in_list, self.category_name, self.description, self.response_text,
     self.category_response_type.present? ? self.category_response_type.response_text : '',
     self.assigned_to.present? ? self.assigned_to.name : '',
     self.category_status_type.present? ? self.category_status_type.status_text : '',
     self.action_needed, self.rule_change_made, self.comments.order(:source_id).collect{|com| com.order_in_list}.join(", "),
     self.num_comments, self.num_commenters]
  end

end
