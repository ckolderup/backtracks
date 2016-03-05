class PasswordResetMailer < ActionMailer::Base
  def send_token(token)
    mail(to: token.user.email, subject: 'Backtracks Password Reset Requested') do |format|
      format.html { render locals: { token: token } }
    end
  end
end
