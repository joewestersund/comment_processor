# == Schema Information
#
# Table name: suggested_change_status_types
#
#  id            :integer          not null, primary key
#  status_text   :string
#  order_in_list :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  rulemaking_id :integer
#

class SuggestedChangeStatusType < ApplicationRecord
  belongs_to :rulemaking
  has_many :suggested_changes

  validates :status_text, presence: true, uniqueness: { case_sensitive: false, scope: :rulemaking_id }
  validates :order_in_list, numericality: { only_integer: true, greater_than: 0}, uniqueness: {scope: :rulemaking_id }

  def self.default_list
    ['needs review',
     'under review',
     'team discussion needed',
     'decision made, need to write draft response',
     'draft response written, assigned to final reviewer',
     'final review complete, has been proofread for tone',
     'other, see action needed']
  end

end
