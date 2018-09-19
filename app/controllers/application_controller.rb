class ApplicationController < ActionController::Base

  def home
    render html: I18n.t('hello')
  end
end
