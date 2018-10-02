class ActionWatcher < ApplicationRecord

  # Méthode qui procède au démarrage du module. C'est l'user qui
  # le lance.
  #
  def execute
    require_relative 'demarrage_module'
    if start_icmodule
      success_message = I18n.t('module.started')
    else
      failure_message = I18n.t('module.unstarted')
    end
  end

end
