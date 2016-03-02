class HomeController < ApplicationController
  before_filter :ensure_logged_in, only: :this_week
  def index
  end

  def latest
    if params[:slug].nil?
      if current_user
        redirect_to latest_url(current_user.slug) and return
      else
        redirect_to(not_found_path) and return
      end
    end

    this_user = User.where(slug: params[:slug]).first

    if this_user.present? && (this_user.public_chart? || current_user == this_user)
      if this_user.last_email_contents.blank? || params[:force]
        html = Email::Compiler.chart_v1(current_user.lastfm_username)[:chart]
        current_user.update(last_email_contents: html)
      end

      @email = this_user.last_email_contents.html_safe
      @lastfm_user = this_user.lastfm_username
      render and return
    else
      redirect_to(not_found_path) and return
    end
  end
end
