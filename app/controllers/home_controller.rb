class HomeController < ApplicationController
  before_filter :ensure_logged_in, only: :this_week
  def index
  end

  def latest
    if current_user.last_email_contents.blank?
      html = Email::Compiler.chart_v1(current_user.lastfm_username)
      current_user.update(last_email_contents: html)
    end
    render :text => current_user.last_email_contents, layout: false
  end
end
