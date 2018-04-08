class PasswordRecoveriesController < ApplicationController
  before_action :to_account_page_if_logged_in

  def new
  end

  def create
    params.permit(:email)
    user = User.find_by_email(params[:email])

    recovery = PasswordRecoveryToken.create(user: user)

    Resque.enqueue(PasswordReset, recovery.id, params[:email])

    flash[:message] ='Thanks! An email will be sent with further instructions.'
    redirect_to log_in_path
  end

  def lookup
    @recovery = PasswordRecoveryToken.find_by_token(params[:token])

    if @recovery.present?
      @user = @recovery.user

      render :reset and return
    else
      flash[:warning] = "Invalid recovery token. If you were trying to reset a password, please request a new password reset email."
      redirect_to log_in_path
    end
  end

  def reset
    @recovery = PasswordRecoveryToken.find_by_token(params[:recovery_token])

    if @recovery.present? &&
       @recovery.user.email == params[:email] &&
       params[:password] == params[:password_confirmation] &&
       @recovery.user.update(password: params[:password])
    then
      @recovery.destroy
      flash[:message] = 'Password reset! Please log in with your new password.'
    else
      flash[:error] = 'Could not reset password. If you believe this is in error, please contact feedback@narratron.com.'
    end
    redirect_to log_in_path
  end
end
