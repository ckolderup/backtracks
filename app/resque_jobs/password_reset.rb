class PasswordReset
  @queue = :housekeeping

  def self.perform(token)
    PasswordResetMailer.send_token(token).deliver
  end
end
