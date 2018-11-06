class UserMailer < ApplicationMailer

  # Envoi le mail d'activation du compte
  #
  # Attention : ça n'envoie pas le mail.
  def activation_compte(user, ticket)
    @greeting = "Bonjour #{user.name}"
    @user   = user    # pour le mail
    @ticket = ticket  # idem
    mail(to: user.email) # retourné à la méthode appelante
  end

  # Envoi le mail de réinitialisation du mot de passe
  #
  # Attention : ça n'envoie pas le mail (ajouter .deliver_now à la méthode
  # appelante)
  def reset_password(user, ticket)
    @greeting = "Bonjour #{user.name}"
    @user   = user    # pour le mail
    @ticket = ticket  # idem
    mail(to: user.email)
  end
end
