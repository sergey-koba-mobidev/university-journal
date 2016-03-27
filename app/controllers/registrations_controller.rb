class RegistrationsController < Devise::RegistrationsController
  def update
    params[:user].delete(:name) if current_user.student? && params[:user].present? && params[:user][:name].present?
    super
  end
end