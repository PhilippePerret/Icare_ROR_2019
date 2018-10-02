class ActionWatcher < ApplicationRecord

  # La méthode principale qui exécute l'action-watcher quand on invoque
  # sa méthode `run`
  #
  def execute
    puts "JE DOIS PROCÉDER AU DÉMARRAGE DU MODULE"
  end

  def sous_methode_utile

  end
end
