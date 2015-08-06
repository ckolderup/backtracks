class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  after_filter :store_return_to

  protected

  def authorize
    unless current_user && current_user.admin?
      flash[:error] = "Unauthorized access"
      redirect_back_or_default(root_path)
      false
    end
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def current_user
    user_id = cookies.permanent.signed[:user_id]
    @current_user ||= User.where(id: user_id).take if user_id.present?
  end

  def store_return_to
    session[:return_to] = request.url
  end
end
