=begin

  Ce fichier contient des méthodes d'helpers pour simplifier le code des
  mails et aussi le code de l'exécution du watcher.

=end
class ActionWatcher < ApplicationRecord

  # Le sujet peut être défini aussi de cette manière, mais seulement s'il est
  # identique entre les mails
  # def subject
  #
  # end

  def notification_type(cuser)
    if owner?(cuser)
      'main-action-required'
    else
      'simple-notice'
    end
  end

end
