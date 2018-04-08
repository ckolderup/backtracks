class HomeController < ApplicationController
  before_action :ensure_logged_in, only: :this_week
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

    @years = []
    flash[:message] = "We're currently processing these charts! Check back in a few minutes."
    if this_user.present? && (this_user.public_chart? || current_user == this_user)
      if params[:force] ||
         this_user.last_email_updated_at.nil? ||
         (this_user.last_email_contents.blank? &&
          this_user.last_email_updated_at < 1.week.ago)
        Resque.enqueue(CacheChart, this_user.id)
      else
        @years = this_user.last_email_contents
        flash[:message] = nil
      end

      @lastfm_user = this_user.lastfm_username
      render and return
    else
      redirect_to(not_found_path) and return
    end
  end
end
