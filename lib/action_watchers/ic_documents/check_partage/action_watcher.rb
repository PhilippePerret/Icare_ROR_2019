class ActionWatcher < ApplicationRecord

  # La méthode principale qui exécute l'action-watcher quand on invoque
  # sa méthode `run`
  #
  def execute

    # dont_destroy    # Pour ne pas détruire le watcher, pendant conception
    # dont_send_mails # pour ne pas envoyer les mails, idem

    icdocument_id = params[:ic_document][:id]
    dshare = params["icdoc"][icdocument_id]

    begin
      icdocument = IcDocument.find(icdocument_id)
    rescue ActiveRecord::RecordNotFound => e
      raise I18n.t('activerecord.errors.models.record_not_found', {classe: 'IcDocument', id: icdocument_id})
    end

    # Le document doit appartenir au user courant
    icdocument.user == current_user || raise(I18n.t('documents.errors.owner_required'))
    # Le document doit avoir un partage non défini (ATTENTION : cela
    # signifie qu'on ne pourra pas utiliser cette action-watcher pour redéfinir
    # le partage du document)
    (icdocument.option(:original,1) == 0 && icdocument.option(:comments,1) == 0) || begin
      raise I18n.t('documents.errors.sharing.already_defined')
    end

    # On peut procéder à la définition du partage
    dont_save = true
    original_is_shared = dshare[:osh] == '1'
    comments_is_shared = dshare[:csh] == '1'
    icdocument.send(original_is_shared ? :share : :dont_share, :original, dont_save)
    icdocument.set_option(:original, 5, 1, dont_save) # fin de cycle
    icdocument.send(comments_is_shared ? :share : :dont_share, :comments, dont_save)
    icdocument.set_option(:comments, 5, 1, dont_save) # fin de cycle
    icdocument.save_options

    msgs = Array.new
    msgs << I18n.t('documents.sharing.defined', {name: icdocument.original_name})
    if original_is_shared && comments_is_shared
      msgs << I18n.t('documents.sharing.thanks_for_all')
    elsif original_is_shared
      msgs << I18n.t('documents.sharing.only_original')
      msgs << I18n.t('documents.sharing.read_charte')
    elsif comments_is_shared
      msgs << I18n.t('documents.sharing.only_comments')
    else
      msgs << I18n.t('documents.sharing.regret_none')
      msgs << I18n.t('documents.sharing.read_charte')
    end

    self.success_message = msgs.join('<br>')

  rescue Exception => e
    self.failure_message = e.message
  end
  # /execute

end
