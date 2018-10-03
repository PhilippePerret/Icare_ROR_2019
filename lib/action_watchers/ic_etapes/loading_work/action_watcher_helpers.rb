=begin

  Ce fichier contient des méthodes d'helpers pour simplifier le code des
  mails et aussi le code de l'exécution du watcher.

=end
class ActionWatcher < ApplicationRecord

  include ActionView::Helpers::DateHelper

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
      'simple-notice'
    else
      'main-action-required'
    end
  end


  def options_next_days
    60.times.collect do |itime|
      futur_time  = Time.now + itime.days
      distance    = distance_of_time_in_words(Time.now, futur_time)
      ["#{human_date_for(futur_time)} (dans #{distance})", itime]
    end
  end
end
