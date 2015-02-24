class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update]
  before_action AdminOnlyActionCallback, :except => :show

  def index
    @users = User.search(params[:search]).paginate(:per_page => PER_PAGE, :page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    unless current_user.admin?
      unless @user == current_user
        redirect_to :back, :alert => "Access denied."
      end
    end
  end

  def create_manual
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, :notice => "User created."
    else
      render :new
    end
  end

  def update
    if user_params[:password].blank?
      user_params.delete(:password)
      user_params.delete(:password_confirmation)
    end

    successfully_updated = if needs_password?(@user, user_params)
                             @user.update_column(:email, user_params.delete(:email))
                             @user.update(user_params)
                           else
                             @user.update_column(:email, user_params.delete(:email))
                             @user.update_without_password(user_params)
                           end

    if successfully_updated
      redirect_to users_path, :notice => "User updated."
    else
      render :edit
    end
  end

  def new
    @user = User.new
  end

  def edit
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def needs_password?(user, params)
    params[:password].present?
  end

  def user_params
    params.require(:user).permit(:role, :name, :email, :password, :password_confirmation)
  end
end
