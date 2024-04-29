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


end
