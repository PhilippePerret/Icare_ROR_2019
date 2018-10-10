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

  # = Observateur =
  # Cette méthode doit être implémentée si on veut "surveiller" quelque chose
  # qui déterminera l'affichage ou non de la notification.
  # C'est la méthode utilisée, par exemple, pour voir si le partage des documents
  # a été défini. Si c'est le cas, l'action-watcher est détruit, si ce n'est pas
  # le cas, une notification indique à l'user qu'il faut définir le partage de
  # ses documents.
  # Doit retourner TRUE si on doit supprimer l'action-water et ne pas afficher
  # la notification.
  # def watcher
  #   return false # false => garder le watcher + afficher la notification
  # end

end
