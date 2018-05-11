# == Schema Information
#
# Table name: comment_data_sources
#
#  id                   :integer          not null, primary key
#  data_source_name     :string
#  description          :string
#  comment_download_url :string
#  active               :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class CommentDataSource < ApplicationRecord
  has_many :comments
end
