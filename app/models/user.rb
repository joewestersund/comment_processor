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

class User < ApplicationRecord
  has_secure_password #adds authenticate method, etc.
  has_many :user_permissions
  has_many :categories
  has_many :change_log_entries

  before_save { |user| user.email.downcase! }
  before_create :create_remember_token

  validates :name, presence: true, length: { maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100}, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}

  validates :password, :presence =>true, :confirmation => true, :length => { :within => 6..40 }, :on => :create
  validates :password, :confirmation => true, :length => { :within => 6..40 }, :on => :update_password

  validate do
    if self.read_only? && self.admin?
      self.errors.add :base, "cannot be read_only and an admin."
    end
  end

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
    4
  end

  def email_address_with_name
    "#{self.name} <#{self.email}>"
  end

  def generate_password_token!
    self.reset_password_token = generate_pw_token
    self.reset_password_sent_at = Time.now.utc
    save!
  end

  def password_token_valid?(token)
    self.reset_password_token.present? && self.reset_password_token == token && (self.reset_password_sent_at + User.hours_to_reset_password.hours) > Time.now.utc
  end

  private
  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end

  def generate_pw_token
    SecureRandom.hex(10)
  end

end
