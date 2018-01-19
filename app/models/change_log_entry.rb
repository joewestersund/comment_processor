# == Schema Information
#
# Table name: change_log_entries
#
#  id          :integer          not null, primary key
#  description :text
#  comment_id  :integer
#  category_id :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ChangeLogEntry < ApplicationRecord

  belongs_to :comment, optional: true
  belongs_to :category, optional: true
  belongs_to :user

end
