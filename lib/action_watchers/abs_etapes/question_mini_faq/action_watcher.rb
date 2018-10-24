class ActionWatcher < ApplicationRecord

  def minifaq
    @minifaq ||= self.objet
  end

  # La méthode principale qui exécute l'action-watcher quand on invoque
  # sa méthode `run`
  #
  def execute

    # dont_destroy    # Pour ne pas détruire le watcher, pendant conception
    # dont_send_mails # pour ne pas envoyer les mails, idem

    # Enregistrement de la réponse à la mini-faq ou destruction de
    # la question si la réponse est vide
    mf_reponse = params[:mini_faq][:reponse].strip

    if mf_reponse.blank?
      # ---------------------------------------------------------------------
      # On doit détruire la question
      minifaq.destroy
      self.success_message = 'La question mini-faq a été détruite.'
    else
      # ---------------------------------------------------------------------
      # On doit enregistrer la réponse
      mf_reponse = mf_reponse.gsub(/\r\n/, "\n").split("\n\n").collect{|p| '<p>%s</p>' % p}.join
      mf_reponse = mf_reponse.gsub(/\n/, '<br>')
      minifaq.update_attributes({
        reponse: mf_reponse,
        state: 1
        })

      # Créer un nouveau watcher pour permettre à l'auteur de la question
      # d'estimer la réponse.
      user.action_watchers.create(name: 'abs_etapes/estimation_reponse_mini_faq', objet: self.objet)

      # Message de confirmation à la fin
      self.success_message = 'La réponse est enregistrée. L’auteur a été prévenu pour qu’il estime la réponse.'
    end

  end

end
