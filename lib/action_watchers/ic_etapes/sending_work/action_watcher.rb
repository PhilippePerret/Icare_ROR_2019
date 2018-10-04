class ActionWatcher < ApplicationRecord

  def icetape
    @icetape ||= objet
  end

  # La méthode principale qui exécute l'action-watcher quand on invoque
  # sa méthode `run`
  #
  def execute
    # dont_destroy      # pour les essais
    # dont_send_mails   # idem

    # On procède à l'envoi du travail. Cela consiste à faire autant
    # d'instance de document que de document envoyés, à les associer à
    # l'étape et à leur attacher le document
    (1..3).each do |idoc|
      field_valeur = params['ic_etape']["original#{idoc}"]
      field_valeur.nil? && next
      # La note attribuée par l'auteur à son travail
      note_auteur = params['ic_etape']["original#{idoc}_note_auteur"]
      # Création du document pour l'étape
      icdocument = ajoute_document_to_icetape(field_valeur, note_auteur)
      # On indique que le document original existe
      icdocument.set_original_exists
    end

    # Passer l'étape à un stade suivant
    # Note : c'est lors du téléchargement qu'on indique la date probable des
    # rendus de commentaires.
    icetape.update_attributes({
      ended_at:   Time.now,
      status:     2
      })

    # Création du watcher permettant à l'administrateur de
    # charger le document
    user.action_watchers.create(name: 'ic_etapes/loading_work', objet: objet)

    # Note : le message final est construit à partir des messages
    # envoyés au cours de l'opération.
  end


  # Retourne l'ic-document créé pour cet envoi
  def ajoute_document_to_icetape(file, note = nil)
    fname = file.original_filename
    # Il faut créer un nouveau document pour l'ic-étape
    icdoc = icetape.ic_documents.create(original_name: fname, note_auteur: note)
    # Il faut attacher cet original à l'instance ic_document
    icdoc.original.attach(file)
    # Ajout d'un message pour l'user qui envoie son travail

    add_success_final(I18n.t('documents.original.upload.success', {name: fname, note: note}))
    # Retourne l'ic-document créé
    return icdoc
  end

end
