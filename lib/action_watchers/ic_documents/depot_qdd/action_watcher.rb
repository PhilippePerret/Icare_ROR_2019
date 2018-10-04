class ActionWatcher < ApplicationRecord

  # La méthode principale qui exécute l'action-watcher quand on invoque
  # sa méthode `run`
  #
  def execute
    puts "Je suis rentré dans l'exécution de l'action-watcher _exemple_type_"

    ## On peut décommenter les lignes suivantes pendant la conception de
    ## l'action-watcher pour ne pas avoir à en recréer tout le temps.
    ##
    # dont_destroy    # Pour ne pas détruire le watcher, pendant conception
    # dont_send_mails # pour ne pas envoyer les mails, idem


  end

  def sous_methode_utile

  end
end
