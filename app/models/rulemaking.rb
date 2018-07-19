# == Schema Information
#
# Table name: rulemakings
#
#  id              :integer          not null, primary key
#  rulemaking_name :string
#  agency          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Rulemaking < ApplicationRecord
  has_many :categories
  has_many :category_response_types
  has_many :category_status_types
  has_many :change_log_entries
  has_many :comments
  has_many :comment_data_sources
  has_many :user_permissions

  validates :rulemaking_name, presence: true, length: { maximum: 50}
  validates :agency, presence: true, length: { maximum: 50}

end
