# == Schema Information
#
# Table name: change_log_entries
#
#  id                  :bigint           not null, primary key
#  action_type         :string
#  description         :text
#  object_type         :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  comment_id          :integer
#  rulemaking_id       :integer
#  suggested_change_id :integer
#  user_id             :integer
#
# Indexes
#
#  index_change_log_entries_on_rulemaking_id_and_created_at     (rulemaking_id,created_at)
#  index_change_log_entries_on_rulemaking_id_and_user_id        (rulemaking_id,user_id)
#  index_cle_on_rulemaking_and_comment_and_created_at           (rulemaking_id,comment_id,created_at)
#  index_cle_on_rulemaking_and_suggested_change_and_created_at  (rulemaking_id,suggested_change_id,created_at)
#
# Foreign Keys
#
#  fk_rails_...  (comment_id => comments.id) ON DELETE => nullify
#  fk_rails_...  (rulemaking_id => rulemakings.id) ON DELETE => cascade
#  fk_rails_...  (suggested_change_id => suggested_changes.id) ON DELETE => nullify
#  fk_rails_...  (user_id => users.id) ON DELETE => restrict
#

class ChangeLogEntry < ApplicationRecord

  belongs_to :rulemaking
  belongs_to :comment, optional: true
  belongs_to :suggested_change, optional: true
  belongs_to :user

end
