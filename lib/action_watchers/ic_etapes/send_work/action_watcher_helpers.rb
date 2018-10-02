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

  # Le type de la notification (le LI la contenant), en fonction du user
  #
  # Les types sont :
  #   'main-action-required'  Une action importante requise
  #   'action-required'       Une action mise en avant
  #   'simple-notice'         Une simple note pour information (discrète)
  # 
  def notification_type(cuser)
    if owner?(cuser)
      'action-required'
    else
      'simple-notice'
    end
  end


end
