class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Classes incluses
  include SessionsHelper
  include TicketsHelper

  def home

  end


  # Méthodes générales servant pour les before_action:

  def logged_in_user
    return if current_user?
    store_original_url
    flash[:danger] = I18n.t('users.asked_for.login')
    redirect_to login_url
  end

  def correct_user
    return if current_user? && (params[:id].nil? || current_user.id == params[:id].to_i)
    flash[:danger] = I18n.t('action.errors.not_autorised', {e: current_user? ? current_user.f_e : ''})
    redirect_to home_path
  end

  def only_for_admin
    return if current_user? && current_user.admin?
    flash[:danger] = I18n.t('action.errors.not_enough_privileges')
    redirect_to home_path
  end

end
