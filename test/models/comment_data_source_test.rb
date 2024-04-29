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

require 'test_helper'

class CommentDataSourceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
