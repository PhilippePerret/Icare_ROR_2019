class ActionWatchersController < ApplicationController
  def run

    # On joue le watcher
    aw = ActionWatcher.find(params[:id]).run_for(current_user, params)

    aw.success_message.blank?   || flash[:success] = aw.success_message
    aw.danger_message.blank?    || flash[:danger]  = aw.danger_message
  rescue ActiveRecord::RecordNotFound => e
    flash[:danger] = I18n.t('activerecord.errors.models.record_not_found', {classe: 'ActionWatcher', id: params[:id]})
  ensure
    if aw.redirect?
      redirect_to(aw.redirection)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
  end
end
