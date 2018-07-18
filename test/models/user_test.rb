# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string
#  email                  :string
#  password_digest        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  remember_token         :string
#  application_admin      :boolean
#  active                 :boolean
#  last_rulemaking_viewed :integer
#  reset_password_token   :string
#  reset_passwod_sent_at  :datetime
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
