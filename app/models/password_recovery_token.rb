class PasswordRecoveryToken < ActiveRecord::Base
  validate :token, presence: true
  validate :user, presence: true

  belongs_to :user

  before_create :generate_token

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end
