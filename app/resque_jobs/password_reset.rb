class PasswordReset
  @queue = :housekeeping

  def self.perform(token_id)
    PasswordResetMailer.send_token(token_id).deliver
  end
end
