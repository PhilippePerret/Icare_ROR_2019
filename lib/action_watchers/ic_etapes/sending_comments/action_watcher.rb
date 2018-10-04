class ActionWatcher < ApplicationRecord

  def icetape
    @icetape ||= objet
  end
  # La méthode principale qui exécute l'action-watcher quand on invoque
  # sa méthode `run`
  #
  def execute
    # dont_destroy

    # Enregistrer tous les documents commentaires s'ils existent
    nombre_comments = 0
    icetape.ic_documents.each do |icdocument|
      comments_file = params['ic_etape']["comments-#{icdocument.id}"]
      comments_file.nil? && next
      # Marquer que le document commentaire existe pour ceux qui ont été
      # envoyés
      ajoute_comments_to_icetape(comments_file, icdocument)
      # Pour savoir combien il y a de documents commentés
      nombre_comments += 1
    end


    if nombre_comments > 0
      # Passer l'étape au statut suivant
      icetape.update_attribute(:status, 4)
      # Créer le watcher suivant : pour permettre à l'icarien(ne) de
      # télécharger les commentaires
      user.action_watchers.create(name: 'ic_etapes/loading_comments', objet: icetape)
    else
      # <= pas de documents commentaires
      # Passer l'étape au statut suivant
      icetape.update_attribute(:status, 7) # fin de cycle
      # => Ne pas envoyer de mail      
      dont_send_mails
    end
  end

  # Retourne l'ic-document créé pour cet envoi
def ajoute_comments_to_icetape(file, icdoc)
  fname = file.original_filename
  # Il faut attacher ce commentaire à l'instance ic_document
  icdoc.comments.attach(file)
  icdoc.set_comments_exists
  # Ajout d'un message pour l'admin qui transmet les commentaires
  add_success_final(I18n.t('documents.comments.upload.success', {name: fname}))
end

end
