class ActionWatcher < ApplicationRecord

  # La méthode principale qui exécute l'action-watcher quand on invoque
  # sa méthode `run`
  #
  def execute
    ## On peut décommenter les lignes suivantes pendant la conception de
    ## l'action-watcher pour ne pas avoir à en recréer tout le temps.
    ##
    # dont_destroy    # Pour ne pas détruire le watcher, pendant conception
    # dont_send_mails # pour ne pas envoyer les mails, idem

    original_pdf = params['qdd']['original']
    original_pdf || raise(I18n.t('documents.qdd.errors.required'))

    # On dépose les deux fichiers sur le qdd des docs
    depose_documents_sur_qdd(original_pdf)

    # Une petite vérification s'impose
    # Raise en cas d'erreur
    check_si_documents_existent_sur_qdd

    # Il faut vérifier si tous les documents de l'étape ont été
    # traités. Si c'est le cas, on peut passer l'étape à l'état suivant
    if tous_les_documents_traited?
      fin_traitement_documents_etape
    else
      self.success_message = I18n.t('documents.qdd.success.depot.one')
    end

    detruit_documents_provisoires

  rescue Exception => e
    self.failure_message = e.message
    puts e.message
    puts e.backtrace[0..5].join("\n")
  end

  # Méthode appelée lorsque l'on a traité tous les documents de l'étape
  def fin_traitement_documents_etape
    icetape.next_state
    self.success_message = I18n.t('documents.qdd.success.depot.all')
    # Il faut fabriquer un ticket pour l'user pour qu'il partage ses documents
    # simplement en cliquant sur un lien de son mail. De toute façon, on crée
    # les watchers qui permettront de définir ce partage (ces watchers seront
    # détruits si le lien-ticket du mail est utilisé)
    ticket = Ticket.new(
      name:     'partage_documents',
      action:   'IcEtape.find(%{etp_id}).partage_all_documents' % {etp_id: icetape.id}
      duree:    30.days
    )
    token = ticket.token
    self.ticket = user.tickets.create(ticket.hash_to_create)
  end
  # /fin_traitement_documents_etape


  def check_si_documents_existent_sur_qdd
    File.exist?(icdocument.original_qdd_path) || raise(I18n.t('documents.qdd.errors.original.unfound', {path: icdocument.original_qdd_path}))
    if icdocument.commented?
      File.exist?(icdocument.comments_qdd_path) || raise(I18n.t('documents.qdd.errors.comments.unfound', {path: icdocument.original_qdd_path}))
    end
  end
  # /check_si_documents_existent_sur_qdd

  # Retourne True si tous les documents de l'étape ont été traités
  def tous_les_documents_traited?
    icetape.ic_documents.each do |icdocument|
      icdocument.on_qdd? || (return false)
    end
    return true
  end
  def icdocument
    @icdocument ||= objet
  end
  def icetape
    @icetape ||= icdocument.ic_etape
  end

  def depose_documents_sur_qdd(original_pdf)
    `mkdir -p "#{Rails.root.join('public','qdd')}"`
    File.open(icdocument.original_qdd_path,'wb') do |f|
      f.write(original_pdf.read)
    end
    if icdocument.comments?
      File.open(icdocument.comments_qdd_path,'wb') do |f|
        f.write(icdocument.comments.download)
      end
    end
  end
  # /depose_documents_sur_qdd

  # Maintenant que les documents ont été déposé sur le Quai des docs, on
  # peut détruire ceux d'ActiveStorage
  def detruit_documents_provisoires
    icdocument.original.purge
    icdocument.comments.purge if icdocument.commented?
  end
  # /detruit_documents_provisoires
end
