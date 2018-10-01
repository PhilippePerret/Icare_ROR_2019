class ActionWatchersController < ApplicationController
  def run
    aw = ActionWatcher.find(params[:id]).run_for(current_user, params)
    puts "aw.success_message.blank? = #{aw.success_message.blank?.inspect}"
    puts "aw.danger_message.blank? = #{aw.danger_message.blank?.inspect}"
    aw.success_message.blank?   || flash[:success] = aw.success_message
    aw.danger_message.blank?    || flash[:danger]  = aw.danger_message
  rescue ActiveRecord::RecordNotFound => e
    flash[:danger] = I18n.t('activerecord.errors.models.record_not_found', {classe: 'ActionWatcher', id: params[:id]})
  ensure
    redirect_back(fallback_location: root_path)
  end

  def destroy
  end
end
