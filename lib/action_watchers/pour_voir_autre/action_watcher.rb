class ActionWatcher < ApplicationRecord

  def execute
    puts "On est dans l'execute de pour-voir-autre, cette fois avec un objet  de class #{objet.class} et d'identifiant #{objet.id}"
  end

end
