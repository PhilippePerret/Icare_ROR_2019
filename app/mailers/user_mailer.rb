class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_compte.subject
  #
  def activation_compte(user)
    @greeting = "Bonjour #{user.name}"
    @user = user # pour le mail
    @user.ticket_token ||= SessionsHelper.new_token # non défini quand preview
    @url_for_ticket = ticket_run_url(@user.tickets.last.id, token: user.ticket_token)
    mail(to: user.email) # retourné à la méthode appelante
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password.subject
  #
  def reset_password(user)
    @greeting = "Bonjour #{user.name}"

    mail( to: user.email, subject: 'Modification du mot de passe')
  end
end
