class UserMailer < ApplicationMailer

  # Envoi le mail d'activation du compte
  #
  # Attention : ça n'envoie pas le mail.
  def activation_compte(user, ticket)
    @greeting = "Bonjour #{user.name}"
    @user = user # pour le mail
    @user.ticket_token ||= SessionsHelper.new_token # non défini quand preview
    @url_for_ticket = ticket_run_url(ticket.id, token: ticket.token)
    mail(to: user.email) # retourné à la méthode appelante
  end

  # Envoi le mail de réinitialisation du mot de passe
  #
  # Attention : ça n'envoie pas le mail (ajouter .deliver_now à la méthode
  # appelante)
  def reset_password(user, ticket)
    @greeting = "Bonjour #{user.name}"
    @user = user
    @url_for_ticket = ticket_run_url(ticket.id, token: ticket.token)
    mail(to: user.email)
  end
end
