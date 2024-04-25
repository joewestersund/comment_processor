# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  name                      :string
#  email                     :string
#  password_digest           :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  remember_token            :string
#  application_admin         :boolean
#  active                    :boolean
#  last_rulemaking_viewed_id :integer
#  reset_password_token      :string
#  password_reset_sent_at    :datetime
#

class User < ActiveRecord::Base
  has_secure_password #adds authenticate method, etc.

  has_many :user_permissions, dependent: :destroy
  has_many :suggested_changes
  has_many :change_log_entries
  belongs_to :last_rulemaking_viewed, class_name: 'Rulemaking', foreign_key: 'last_rulemaking_viewed_id', optional: true

  before_save { |user| user.email.downcase! }
  before_create :create_remember_token

  validates :name, presence: true, length: { maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # note: email address should always be lowercase in the database. This is enforced in users_controller.create
  validates :email, presence: true, length: { maximum: 100}, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}

  validates :password, length: { minimum: 6 }, if: :password_digest_changed?

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.hours_to_reset_password
    1
  end

  def User.hours_to_do_first_login
    24
  end

  def email_address_with_name
    "#{self.name} <#{self.email}>"
  end

  def generate_password_token!
    self.reset_password_token = generate_pw_token
    self.password_reset_sent_at = Time.now.utc
    save!
  end

  def password_token_valid?
    if (self.created_at + User.hours_to_do_first_login.hours) > Time.now.utc
      #new user gets hours_to_do_first_login to do their password reset
      true
    else
      #established user gets hours_to_reset_password
      (self.password_reset_sent_at + User.hours_to_reset_password.hours) > Time.now.utc
    end
  end

  def admin_for?(rulemaking)
    return false if rulemaking.nil?
    if self.application_admin?
      return true
    else
      up = self.user_permissions.find_by(rulemaking: rulemaking)
      return up.present? && up.admin?
    end
  end

  def can_edit?(rulemaking)
    return false if rulemaking.nil?
    if self.application_admin?
      return true
    else
      up = self.user_permissions.find_by(rulemaking: rulemaking)
      return up.present? && !up.read_only?
    end
  end

  def can_view?(rulemaking)
    return false if rulemaking.nil?
    if self.application_admin?
      return true
    else
      up = self.user_permissions.find_by(rulemaking: rulemaking)
      return up.present?
    end
  end

  def rulemakings
    if self.application_admin?
      Rulemaking.all
    else
      Rulemaking.where(id: self.user_permissions.select(:rulemaking_id))
    end
  end

  private
  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end

  def generate_pw_token
    SecureRandom.hex(10)
  end

end
