class User < ActiveRecord::Base
  attr_accessor :password
  attr_readonly :slug

  serialize :last_email_contents, Array

  before_save :encrypt_password
  before_save :downcase_email
  before_update { |user| user.send(:bump_last_email_updated) if user.last_email_contents_changed? }
  before_create :generate_slug

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_presence_of :display_name
  validates_presence_of :lastfm_username
  validates_uniqueness_of :email, case_sensitive: false, message: 'address already reserved. Did you forget your password?'

  def self.authenticate(email, password)
    user = User.where(email: email.downcase).take
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  private

  def downcase_email
    self.email = self.email.downcase
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def generate_slug
    self.slug = Base64.encode64(SecureRandom.uuid)[0..10]
  end

  def bump_last_email_updated
    self.last_email_updated_at = DateTime.now
  end
end
