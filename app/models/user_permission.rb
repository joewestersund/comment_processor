# == Schema Information
#
# Table name: user_permissions
#
#  id            :integer          not null, primary key
#  admin         :boolean
#  read_only     :boolean
#  user_id       :integer
#  rulemaking_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class UserPermission < ApplicationRecord
  belongs_to :rulemaking
  belongs_to :user
end
