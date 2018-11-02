class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Classes incluses
  include UsersHelper
  include SessionsHelper

  def home

  end


  # Méthodes générales servant pour les before_action:

  def logged_in_user
    return if real_user?
    store_original_url
    flash[:danger] = I18n.t('users.asked_for.login')
    redirect_to login_url
  end

  def correct_user
    return if (params[:id].nil? || current_user.id == params[:id].to_i)
    flash[:danger] = I18n.t('action.errors.not_autorised'.sexize(current_user))
    redirect_to home_path
  end

  def only_for_admin
    return if current_user.admin?
    flash[:danger] = I18n.t('action.errors.not_enough_privileges'.sexize(current_user))
    redirect_to home_path
  end

end
