class UsersController < ApplicationController
  skip_after_action :store_return_to
  before_action :ensure_logged_in, only: [:update, :edit]
  before_action :to_account_page_if_logged_in, only: [:new, :create]

  def new
    @user = User.new
  end

  def update
    @user = User.where(id: user_params[:id]).take

    if @user != current_user
      flash[:message] = "Access denied!"
      redirect_to account_path
    elsif @user.update(user_params)
      flash[:message] = "Details updated!"
      redirect_to account_path
    else
      render "edit"
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      cookies.permanent.signed[:user_id] = @user.id
      flash[:message] = "Signed up!"

      Resque.enqueue(EmailChart, @user)
      redirect_to account_path
    else
      render "new"
    end
  end

  def edit
    @user = current_user
    @updating = true
    @user.password = ''
  end

  private

  def user_params
    params.require(:user).permit(:id, :email, :display_name, :lastfm_username,
      :password, :password_confirmation, :send_weekly_email, :public_chart)
  end
end
