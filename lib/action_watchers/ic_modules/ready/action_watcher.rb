class ActionWatcher < ApplicationRecord

  # Méthode qui procède au démarrage du module. C'est l'user qui
  # le lance.
  #
  def execute
    require_relative 'demarrage_module'
    if start_icmodule
      success_message = I18n.t('ic_modules.starting.success')
    else
      failure_message = I18n.t('ic_modules.starting.failure')
    end
  end

end
