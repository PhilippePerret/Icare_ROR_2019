class ActionWatcher < ApplicationRecord

  # La méthode principale qui exécute l'action-watcher quand on invoque
  # sa méthode `run`
  #
  def execute

    # On a juste à détruire le ticket associé à ce watcher
    objet.destroy

  end

end
