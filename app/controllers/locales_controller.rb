class LocalesController < ApplicationController
  LOCALES = %w(en ru ua)
  def change
    cookies[:locale] = params[:locale] if I18n.available_locales.map(&:to_s).include?(params[:locale])
    redirect_to :back
  end
end
