class SessionsController < ApplicationController
  skip_after_filter :store_return_to
  before_filter :to_account_page_if_logged_in, except: :destroy

  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      cookies.permanent.signed[:user_id] = user.id
      flash[:message] = "Logged in!"
      redirect_to account_path
    else
      flash[:error] = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    cookies.permanent.signed[:user_id] = nil
    flash[:message] = "Logged out!"
    redirect_to root_path
  end
end
