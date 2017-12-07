# == Schema Information
#
# Table name: comments
#
#  id                     :integer          not null, primary key
#  source_id              :integer
#  first_name             :string
#  last_name              :string
#  email                  :string
#  organization           :string
#  state                  :string
#  comment_text           :string
#  attachment_url         :string
#  summary                :string
#  comment_status_type_id :integer
#  action_needed          :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  attachment_name        :string
#  manually_entered       :boolean
#

class Comment < ApplicationRecord
  has_and_belongs_to_many :categories
  belongs_to :comment_status_type
end
