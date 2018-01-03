# == Schema Information
#
# Table name: comment_tone_types
#
#  id            :integer          not null, primary key
#  tone_text     :string
#  order_in_list :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class CommentToneType < ApplicationRecord
  has_many :comments

  validates :tone_text, presence: true, uniqueness: { case_sensitive: false }
  validates :order_in_list, numericality: { only_integer: true, greater_than: 0}, uniqueness: true

end
