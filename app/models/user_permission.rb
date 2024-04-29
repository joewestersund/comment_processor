# == Schema Information
#
# Table name: user_permissions
#
#  id            :bigint           not null, primary key
#  admin         :boolean
#  read_only     :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  rulemaking_id :integer
#  user_id       :integer
#
# Foreign Keys
#
#  fk_rails_...  (rulemaking_id => rulemakings.id) ON DELETE => cascade
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade
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
