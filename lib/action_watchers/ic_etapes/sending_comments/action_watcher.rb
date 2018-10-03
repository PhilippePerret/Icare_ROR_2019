class ActionWatcher < ApplicationRecord

  # La méthode principale qui exécute l'action-watcher quand on invoque
  # sa méthode `run`
  #
  def execute
    dont_destroy
    dont_send_mails
    
    # TODO Marquer que le document commentaire existe pour ceux qui ont été
    # envoyés
  end

end
