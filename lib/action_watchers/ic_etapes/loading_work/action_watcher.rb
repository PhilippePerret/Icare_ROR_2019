class ActionWatcher < ApplicationRecord

  # La méthode principale qui exécute l'action-watcher quand on invoque
  # sa méthode `run`
  #
  def execute
    dont_destroy      # Pour l'essai
    dont_send_mails   # idem

    # TODO Marquer que les documents ont été reçus par phil
    # TODO Indiquer la date probable du rendu des commentaires
    # TODO Passer l'étape au stade suivant
  end

  # Date humaine de remise des commentaires, pour le mail principalement
  def human_date_remise_commentaires
    '12 octobre 3033'
  end

  def sous_methode_utile

  end
end
