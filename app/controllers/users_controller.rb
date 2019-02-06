class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update]
  before_action AdminOrTeacherActionCallback, :except => :show

  def index
    @users = User.search(params[:search]).paginate(:per_page => PER_PAGE, :page => params[:page])
    @users = @users.student if current_user.teacher?
  end

  def show
    @user = User.find(params[:id])
    unless current_user.admin? || current_user.teacher?
      unless @user == current_user
        redirect_back fallback_location: root_path, :alert => "Access denied."
      end
    end
  end

  def create_manual
    @user = User.new(user_params)
    @user.email = @user.email.downcase
    if (!@user.student? and !current_user.admin?)
      redirect_to users_path, alert: "Access denied!"
    else
      #@user.skip_confirmation!
      if @user.save
        if params[:group_id].present?
          group = Group.find(params[:group_id])
          @user.groups << group
          group.touch
        end
        redirect_to users_path, notice: "User created."
      else
        render :new
      end
    end
  end

  def update
    if (user_params[:role]!='student' and !current_user.admin?)
      redirect_to users_path, alert: "Access denied!" and return
    end

    user_params.delete(:name) if current_user.student? && user_params[:name].present?

    if user_params[:password].blank?
      user_params.delete(:password)
      user_params.delete(:password_confirmation)
    end

    successfully_updated = if needs_password?(@user, user_params)
                             @user.update_column(:email, user_params.delete(:email).downcase)
                             @user.update(user_params)
                           else
                             @user.update_column(:email, user_params.delete(:email).downcase)
                             @user.update_without_password(user_params)
                           end

    if successfully_updated
      # for caching purpose
      @user.groups.each do |group|
        group.touch
      end

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
    if (!user.student? and !current_user.admin?)
      redirect_to users_path, alert: 'Access denied!' and return
    end
    if user.destroy
      redirect_to users_path, :notice => 'User deleted.'
    else
      redirect_to users_path, alert: user.errors.full_messages.join('. ')
    end
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
