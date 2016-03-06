class ChartMailer < ApplicationMailer
  def v1(user_id, email_override=nil)
    user = User.find(user_id)
    years = Charts.v1(user.lastfm_username)
    return if years.empty?

    mail(to: email_override || user.email, subject: 'Your Backtracks for the Week') do |format|
      format.html { render locals: { years: years } }
    end
  end
end
