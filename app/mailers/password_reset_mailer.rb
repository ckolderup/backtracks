class PasswordResetMailer < ApplicationMailer
  def send_token(token_id)
    token = PasswordRecoveryToken.find(token_id)

    mail(to: token.user.email, subject: 'Backtracks Password Reset Requested') do |format|
      format.html { render locals: { token: token } }
    end
  end
end
