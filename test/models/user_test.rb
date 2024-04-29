# == Schema Information
#
# Table name: users
#
#  id                        :bigint           not null, primary key
#  active                    :boolean
#  application_admin         :boolean
#  email                     :string
#  name                      :string
#  password_digest           :string
#  password_reset_sent_at    :datetime
#  remember_token            :string
#  reset_password_token      :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  last_rulemaking_viewed_id :integer
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
