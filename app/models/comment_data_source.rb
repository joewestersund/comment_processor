# == Schema Information
#
# Table name: comment_data_sources
#
#  id                   :bigint           not null, primary key
#  active               :boolean
#  comment_download_url :string
#  data_source_name     :string
#  description          :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  rulemaking_id        :integer
#
# Foreign Keys
#
#  fk_rails_...  (rulemaking_id => rulemakings.id) ON DELETE => cascade
#

class CommentDataSource < ApplicationRecord
  belongs_to :rulemaking
  has_many :comments

  validates :data_source_name, presence: true, uniqueness: { case_sensitive: false, scope: :rulemaking_id }
  validates :comment_download_url, uniqueness: { case_sensitive: false, scope: :rulemaking_id }

  def self.default_list
    ['Comment Period #1']
  end

end
