# == Schema Information
#
# Table name: comment_status_types
#
#  id            :integer          not null, primary key
#  status_text   :string
#  order_in_list :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  rulemaking_id :integer
#  color_name    :string
#

class CommentStatusType < ApplicationRecord
  belongs_to :rulemaking
  has_many :comments

  validates :status_text, presence: true, uniqueness: { case_sensitive: false, scope: :rulemaking_id }
  validates :order_in_list, numericality: { only_integer: true, greater_than: 0}, uniqueness: {scope: :rulemaking_id }

  def self.default_list
    #default status_text and color_name
    [
        ['needs review', 'indianred'],
        ['first review complete', 'yellow'],
        ['second review complete','forestgreen']
    ]
  end

end
