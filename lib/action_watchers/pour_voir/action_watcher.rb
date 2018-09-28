class ActionWatcher < ApplicationRecord

  def execute
    puts "Je suis rentré dans l'exécution de l'action-watcher de pour-voir"
    puts "L'objet est de class #{objet.class} et d'identifiant #{objet.id}"
  end

end
