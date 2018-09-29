class BureauController < ApplicationController

  before_action :logged_in_user

  def home
    @user = current_user
    @action_watchers = @user.admin? ? ActionWatcher.all : @user.action_watchers
  end

  def historique
  end

  def documents
  end

  private

    
end
