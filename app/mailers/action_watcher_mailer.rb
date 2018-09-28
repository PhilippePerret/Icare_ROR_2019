class ActionWatcherMailer < ApplicationMailer

  # Envoi le mail d'activation du compte
  #
  # Attention : ça n'envoie pas le mail.
  def send_to_user(action_watcher, mail_body, mail_subject)
    mail(to: action_watcher.user.email, subject: mail_subject) do |fmt|
      fmt.html { render html: mail_body }
    end
  end

  # Envoi le mail de réinitialisation du mot de passe
  #
  # Attention : ça n'envoie pas le mail (ajouter .deliver_now à la méthode
  # appelante)
  def send_to_admin(action_watcher, mail_body, mail_subject)
    mail(from: action_watcher.user.email, subject: mail_subject) do |fmt|
      fmt.html { render html: mail_body }
    end
  end
  
end
