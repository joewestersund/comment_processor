# == Schema Information
#
# Table name: categories
#
#  id                      :integer          not null, primary key
#  category_name           :string
#  summary                 :string
#  response_text           :string
#  assigned_to             :integer
#  category_status_type_id :integer
#  action_needed           :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  order_in_list           :integer
#

class Category < ApplicationRecord
  has_and_belongs_to_many :comments
  belongs_to :category_status_type
  belongs_to :user, foreign_key: 'assigned_to', optional: true

  validates :category_name, presence: true, uniqueness: { case_sensitive: false }
  validates :order_in_list, numericality: { only_integer: true, greater_than: 0}, uniqueness: true

  def self.csv_header
    ['Order In List', 'ID', 'Category Name', 'Summary', 'Response Text', 'Assigned To',
     'Status', 'Action Needed', 'Comments by ID']
  end

  def to_csv
    [self.order_in_list, self.id, self.category_name, self.summary, self.response_text, self.assigned_to.present? ? User.find(self.assigned_to).name : '',
     self.category_status_type.status_text, self.action_needed, self.comments.order(:source_id).collect{|com| com.id}.join(", ")]
  end

end
