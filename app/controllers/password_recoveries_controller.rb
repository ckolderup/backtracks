class PasswordRecoveriesController < ApplicationController
  def new
  end

  def create
    params.permit(:email)
    user = User.find_by_email(params[:email])

    recovery = PasswordRecoveryToken.create(user_id: user.id)

    Resque.enqueue(PasswordReset, recovery)

    flash[:message] ='Thanks! An email will be sent with further instructions.'
    redirect_to root_path
  end

  def lookup
    @recovery = PasswordRecoveryToken.find(password_recovery_params)

    if @recovery.present?
      @user = @recovery.user

      render :reset and return
    else
      flash[:warning] = "Invalid recovery token. If you were trying to reset a password, please generate a new password recovery email."
      redirect_to root
    end
  end

  def reset
    @recovery = PasswordRecoveryToken.find(password_recovery_params)

    if @recovery.present? &&
       @recovery.user.email == params[:"user[email]"] &&
       @recovery.user.update(user_params)
    then
      @recovery.destroy
      flash[:message] = 'Password reset! Please log in with your new password.'
    else
      flash[:error] = 'Could not reset password. If you believe this is in error, please contact feedback@narratron.com.'
    end
    redirect_to log_in_path
  end
end
