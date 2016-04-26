class PasswordReset
  @queue = :housekeeping

  def self.perform(token_id, email_entered)
    PasswordResetMailer.send_token(token_id).deliver
  end
end
