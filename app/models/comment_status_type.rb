# == Schema Information
#
# Table name: comment_status_types
#
#  id            :integer          not null, primary key
#  status_text   :string
#  order_in_list :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class CommentStatusType < ApplicationRecord
  has_many :comments
end
