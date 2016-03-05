class ChartMailer < ApplicationMailer
  def v1(user, email_override=nil)
    years = Charts.v1(user.lastfm_username)
    return if years.empty?

    mail(to: email_override || user.email, subject: 'Your Backtracks for the Week') do |format|
      format.html { render locals: { years: years } }
    end
  end
end
