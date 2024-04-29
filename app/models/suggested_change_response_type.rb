# == Schema Information
#
# Table name: suggested_change_response_types
#
#  id            :bigint           not null, primary key
#  color_name    :string
#  order_in_list :integer
#  response_text :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  rulemaking_id :integer
#
# Foreign Keys
#
#  fk_rails_...  (rulemaking_id => rulemakings.id) ON DELETE => cascade
#

class SuggestedChangeResponseType < ApplicationRecord
  belongs_to :rulemaking
  has_many :suggested_changes

  validates :response_text, presence: true, uniqueness: { case_sensitive: false, scope: :rulemaking_id }
  validates :order_in_list, numericality: { only_integer: true, greater_than: 0}, uniqueness: {scope: :rulemaking_id }

  def self.default_list
    [
        ['yes, we made changes to address this comment', 'yellowgreen'],
        ['no, we did not make changes to address this comment','yellowgreen'],
        ['no agency response required','dodgerblue']
    ]
  end

end
