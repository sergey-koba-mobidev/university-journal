class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  PER_PAGE = 10

  class AdminOnlyActionCallback
    def self.before(controller)
      unless controller.user_signed_in? && controller.current_user.admin?
        controller.redirect_to :root, :alert => 'Access denied.'
      end
    end
  end

  class AdminOrTeacherActionCallback
    def self.before(controller)
      unless controller.user_signed_in? && (controller.current_user.admin? || controller.current_user.teacher?)
        controller.redirect_to :root, :alert => 'Access denied.'
      end
    end
  end

  def set_locale
    I18n.locale = session[:locale] || I18n.default_locale
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation, :remember_me) }
    #devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :password_confirmation, :current_password) }
  end

  def owner_or_admin(discipline)
    current_user.admin? || current_user.id == discipline.user_id
  end
end
