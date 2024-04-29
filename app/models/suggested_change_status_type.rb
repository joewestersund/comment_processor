# == Schema Information
#
# Table name: suggested_change_status_types
#
#  id            :bigint           not null, primary key
#  color_name    :string
#  order_in_list :integer
#  status_text   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  rulemaking_id :integer
#
# Foreign Keys
#
#  fk_rails_...  (rulemaking_id => rulemakings.id) ON DELETE => cascade
#

class SuggestedChangeStatusType < ApplicationRecord
  belongs_to :rulemaking
  has_many :suggested_changes

  validates :status_text, presence: true, uniqueness: { case_sensitive: false, scope: :rulemaking_id }
  validates :order_in_list, numericality: { only_integer: true, greater_than: 0}, uniqueness: {scope: :rulemaking_id }

  def self.default_list
    [
        ['needs review','indianred'],
        ['under review','yellow'],
        ['team discussion needed','cyan'],
        ['decision made, need to write draft response','dodgerblue'],
        ['draft response written, assigned to final reviewer','yellowgreen'],
        ['final review complete, has been proofread for tone','forestgreen'],
        ['other, see action needed','darkorange'],
    ]
  end

end
