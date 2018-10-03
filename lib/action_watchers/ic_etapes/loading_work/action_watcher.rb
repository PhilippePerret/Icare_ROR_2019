class ActionWatcher < ApplicationRecord

  # La méthode principale qui exécute l'action-watcher quand on invoque
  # sa méthode `run`
  #
  def execute
    # dont_destroy      # Pour l'essai
    # dont_send_mails   # idem

    dans_nombre_jours = params['ic_etape']['date_remise_commentaires'].to_i
    @date_remise = Date.today + dans_nombre_jours.days

    # Marquer que les documents ont été reçus par phil
    marquer_les_documents_recus_par_phil
    # Indiquer la date probable du rendu des commentaires
    # et le statut suivant de l'étape
    update_ic_etape
    # Passer au watcher suivant, qui permettra à l'administrateur de
    # charger ses commentaires
    user.action_watchers.create(name: 'ic_etapes/sending_comments', objet: icetape)
    # Message de confirmation
    self.success_message = I18n.t('ic_etapes.setup.success')
  end

  def icetape
    @icetape ||= objet
  end

  def marquer_les_documents_recus_par_phil
    icetape.ic_documents.each do |icdocument|
      icdocument.set_option(:original, 2, 1)
    end
  end

  def update_ic_etape
    icetape.update_columns({status: 3, expected_comments_at: @date_remise})
  end

  # Date humaine de remise des commentaires, pour le mail principalement
  def human_date_remise_commentaires
    # @human_date_remise_commentaires ||= I18n.localize(@date_remise, format: :simple)
    @human_date_remise_commentaires ||= human_date_for(@date_remise)
  end

end
