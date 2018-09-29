class ActionWatcher < ApplicationRecord

  # La méthode principale qui exécute l'action-watcher quand on invoque
  # sa méthode `run`
  #
  def execute
    puts "Je suis rentré dans l'exécution de l'action-watcher _exemple_type_"
  end

  def sous_methode_utile

  end
end
