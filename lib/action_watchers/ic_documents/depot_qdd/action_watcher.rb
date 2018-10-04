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
    (
      File.exist?(icdocument.original_qdd_path) &&
      (icdocument.commented? == File.exist?(icdocument.comments_qdd_path))
    ) || raise(I18n.t('documents.qdd.errors.docs_unfound'))

    # Il faut vérifier si tous les documents de l'étape ont été
    # traités. Si c'est le cas, on peut passer l'étape à l'état suivant
    if tous_les_documents_traited?
      icetape.next_state
      self.success_message = I18n.t('documents.qdd.success.depot.all')
    else
      self.success_message = I18n.t('documents.qdd.success.depot.one')
    end

    detruit_documents_provisoires

  end

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
    # TODO Note : à partir d'ici, on pourrait détruire les deux
    # documents original et commentaire initiaux
  end
  # /depose_documents_sur_qdd

  # Maintenant que les documents ont été déposé sur le Quai des docs, on
  # peut détruire ceux d'ActiveStorage
  def detruit_documents_provisoires
    icdocument.original.purge_later
    icdocument.comments.purge_later if icdocument.commented?
  end
  # /detruit_documents_provisoires
end
