class ActionWatcher < ApplicationRecord

  def minifaq
    @minifaq ||= objet
  end

  # La méthode principale qui exécute l'action-watcher quand on invoque
  # sa méthode `run`
  #
  def execute

    # dont_destroy    # Pour ne pas détruire le watcher, pendant conception
    # dont_send_mails # pour ne pas envoyer les mails, idem

    estimation = params[:mini_faq][:estimation].to_i # 2 ou 3

    # Définir le texte ajouté
    ajout =
      case estimation
      when 2 then ''
      when 3 then ' Phil va essayer de l’améliorer pour vous satisfaire.'
      end

    # On enregistrement l'estimation
    minifaq.update_attribute(:state, estimation)

    # TODO Si l'évaluation est mauvaise, il faut bien le signaler dans le mail
    # envoyé à l'administration.

    # Message final
    self.success_message = "Merci, votre estimation a bien été prise en compte.#{ajout}"
  end

end
