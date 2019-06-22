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

  validate do
    if self.read_only? && self.admin?
      self.errors.add :base, "cannot be read_only and an admin."
    end
  end

  validates :user_id, uniqueness: { scope: :rulemaking }

end
